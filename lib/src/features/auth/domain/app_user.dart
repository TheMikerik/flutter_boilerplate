import 'package:supabase_flutter/supabase_flutter.dart';

// Abstracted user, might add username later (it's already in profiles table)
// https://codewithandrea.com/articles/abstraction-repository-pattern-flutter/
abstract class AppUser {
  String get uid;
  String? get email;
}

class SupabaseAppUser implements AppUser {
  const SupabaseAppUser(this._user);
  final User _user; // private

  @override
  String get uid => _user.id;

  @override
  String? get email => _user.email;
}
