import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: 'lib/env/.env')
final class Env {
  // LOCAL DEV
  @EnviedField(varName: 'SUPABASE_LOCAL_URL', obfuscate: true)
  static final String supabaseLocalUrl = _Env.supabaseLocalUrl;
  @EnviedField(varName: 'SUPABASE_LOCAL_ANON_KEY', obfuscate: true)
  static final String supabaseLocalAnonKey = _Env.supabaseLocalAnonKey;
  @EnviedField(varName: 'POWERSYNC_ANDROID_LOCAL_URL', obfuscate: true)
  static final String powersyncAndroidLocalUrl = _Env.powersyncAndroidLocalUrl;
  @EnviedField(varName: 'POWERSYNC_IOS_LOCAL_URL', obfuscate: true)
  static final String powersyncIOSLocalUrl = _Env.powersyncIOSLocalUrl;

  // PRODUCTION
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static final String supabaseUrl = _Env.supabaseUrl;
  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static final String supabaseAnonKey = _Env.supabaseAnonKey;
  @EnviedField(varName: 'POWERSYNC_URL', obfuscate: true)
  static final String powersyncUrl = _Env.powersyncUrl;

  @EnviedField(varName: 'GOOGLE_SIGN_CLIENT_ID', obfuscate: true)
  static final String googleSignClientId = _Env.googleSignClientId;
  @EnviedField(varName: 'GOOGLE_SIGN_SERVER_CLIENT_ID', obfuscate: true)
  static final String googleSignServerClientId = _Env.googleSignServerClientId;

  @EnviedField(varName: 'SENTRY_DSN', obfuscate: true)
  static final String sentryDsn = _Env.sentryDsn;
}
