import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_status_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<bool> connectionStatus(Ref ref) async* {
  final internetConnection = InternetConnection();
  await for (final status in internetConnection.onStatusChange) {
    yield status == InternetStatus.connected;
  }
}
