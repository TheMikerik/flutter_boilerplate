import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_checker_provider.g.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionCheckerImpl implements ConnectionChecker {
  ConnectionCheckerImpl(this.internetConnection);
  final InternetConnection internetConnection;

  @override
  Future<bool> get isConnected async => internetConnection.hasInternetAccess;
}

@Riverpod(keepAlive: true)
ConnectionChecker connectionChecker(Ref ref) {
  final internetConnection = InternetConnection();
  return ConnectionCheckerImpl(internetConnection);
}
