import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate/src/core/db/schema.dart';
import 'package:flutter_boilerplate/src/core/db/supabase_connector.dart';
import 'package:flutter_boilerplate/src/core/error/app_error.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A singleton manager for the PowerSync database.
class PowerSyncDatabaseManager {
  // Private constructor
  PowerSyncDatabaseManager._internal();

  /// The single instance of this manager.
  static final PowerSyncDatabaseManager instance =
      PowerSyncDatabaseManager._internal();

  /// Our reference to the PowerSyncDatabase.
  late final PowerSyncDatabase _db;

  /// A reference to the connector, if connected.
  SupabaseConnector? _currentConnector;

  /// Whether or not this manager is initialized.
  bool _isInitialized = false;

  /// Initialize the database and set up Supabase auth listeners.
  ///
  /// Call this once, typically at the startup of your app.
  Future<void> initialize() async {
    if (_isInitialized) return; // guard from multiple inits

    _db = PowerSyncDatabase(
      schema: DbSchema.schema,
      path: await _getDatabasePath(),
      logger: attachedLogger,
    );

    await _db.initialize();
    _isInitialized = true;

    // If the user is already logged in, connect immediately
    if (_isLoggedIn()) {
      _currentConnector = SupabaseConnector();
      await _db.connect(connector: _currentConnector!);
    }

    // Listen for auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final event = data.event;

      if (event == AuthChangeEvent.signedIn) {
        // Connect to PowerSync when the user is signed in
        if (_currentConnector == null) {
          _currentConnector = SupabaseConnector();
          await _db.connect(connector: _currentConnector!);
        }
      } else if (event == AuthChangeEvent.signedOut) {
        // Implicit sign out - disconnect, but don't delete data
        _currentConnector = null;
        await _db.disconnect();
      } else if (event == AuthChangeEvent.tokenRefreshed) {
        // Supabase token refreshed - trigger token refresh for PowerSync
        await _currentConnector?.prefetchCredentials();
      }
    });
  }

  /// Explicit sign out - clear database and log out.
  Future<void> logout() async {
    await _db.disconnectAndClear();
  }

  /// db getter
  PowerSyncDatabase get db {
    if (!_isInitialized) {
      throw AppError('Database has not been initialized yet.');
    }
    return _db;
  }

  // Private methods

  bool _isLoggedIn() {
    return Supabase.instance.client.auth.currentSession?.accessToken != null;
  }

  Future<String> _getDatabasePath() async {
    const dbFilename = 'database.db';

    // getApplicationSupportDirectory is not supported on Web
    if (kIsWeb) {
      return dbFilename;
    }

    final dir = await getApplicationSupportDirectory();
    return join(dir.path, dbFilename);
  }
}
