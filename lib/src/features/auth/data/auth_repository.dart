import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate/env/env.dart';
import 'package:flutter_boilerplate/src/core/common/providers/connection_checker_provider.dart';
import 'package:flutter_boilerplate/src/core/error/app_exception.dart';
import 'package:flutter_boilerplate/src/features/auth/domain/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  // Future<void> signOut();
  // Future<void> deleteAccount();
  AppUser? get currentUser;
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required SupabaseClient client,
    required ConnectionChecker connectionChecker,
    required GoogleSignIn googleSignIn,
  })  : _client = client,
        _connectionChecker = connectionChecker,
        _googleSignIn = googleSignIn;

  final SupabaseClient _client;
  final ConnectionChecker _connectionChecker;
  final GoogleSignIn _googleSignIn;

  AppUser? _convertUser(User? user) =>
      user != null ? SupabaseAppUser(user) : null;

  Future<void> _checkInternet() async {
    if (!(await _connectionChecker.isConnected)) {
      throw NoInternetException();
    }
  }

  @override
  Stream<AppUser?> authStateChanges() {
    return _client.auth.onAuthStateChange.map((authState) {
      final session = authState.session;
      if (session == null) {
        return null;
      } else {
        return _convertUser(session.user);
      }
    });
  }

  @override
  AppUser? get currentUser {
    final user = _client.auth.currentSession?.user;
    return _convertUser(user);
  }

  @override
  Future<void> signInWithGoogle() async {
    await _checkInternet();
    final googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      // The user canceled the sign-in
      return;
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw NoAccessTokenException();
    }
    if (idToken == null) {
      throw NoIdTokenException();
    }

    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  // https://supabase.com/docs/guides/auth#third-party-logins
  // https://supabase.com/docs/reference/dart/auth-signinwithidtoken
  @override
  Future<void> signInWithApple() async {
    try {
      await _checkInternet();

      if (Platform.isIOS) {
        // iOS: Use native Sign in with Apple
        final rawNonce = _client.auth.generateRawNonce();
        final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: hashedNonce,
        );

        final idToken = credential.identityToken;
        if (idToken == null) {
          throw const AuthException(
            'Could not find ID Token from generated credential.',
          );
        }
        await _client.auth.signInWithIdToken(
          provider: OAuthProvider.apple,
          idToken: idToken,
          nonce: rawNonce,
        );
      } else {
        // Android: Use OAuth flow with web browser
        await _client.auth.signInWithOAuth(
          OAuthProvider.apple,
          // TODO: android redirect deeplink
          // (+ client secret) if its later than 4.7.2025
          redirectTo:
              kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
          authScreenLaunchMode: kIsWeb
              ? LaunchMode.platformDefault
              : // launch the auth screen in a new webview on mobile.

              LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      if (e is SignInWithAppleAuthorizationException) {
        // User explicitly cancelled the sign-in flow
        return;
      }

      rethrow;
    }
  }

  // @override
  // Future<void> signOut() async {
  //   // these shouldn't depend on each other, so we can run them in parallel
  //   await Future.wait([
  //     // idk the difference between this below and signOut lol
  //     // await _googleSignIn.disconnect();

  //     _googleSignIn.signOut(),
  //     _client.auth.signOut(),
  //     PowerSyncDatabaseManager.instance.logout(), // explicit logout
  //   ]);
  // }

  // @override
  // Future<void> deleteAccount() async {
  //   // postgres function defined in Supabase SQL
  //   await _client.rpc<void>('delete_user');
  //   await Future.wait([
  //     _googleSignIn.signOut(),
  //     _client.auth.signOut(scope: SignOutScope.global),
  //     PowerSyncDatabaseManager.instance.logout(), // explicit logout
  //   ]);
  // }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final connectionChecker = ref.watch(connectionCheckerProvider);

  final googleSignIn = GoogleSignIn(
    scopes: ['https://www.googleapis.com/auth/userinfo.email'],
    clientId: Env.googleSignClientId,
    serverClientId: Env.googleSignServerClientId,
  );

  return AuthRepositoryImpl(
    client: Supabase.instance.client,
    connectionChecker: connectionChecker,
    googleSignIn: googleSignIn,
  );
}

// usage: final user = ref.watch(authStateChangesProvider).value;
@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}
