import 'package:flutter_boilerplate/src/core/error/app_exception.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> checkPermission(Permission permission) async {
  var status = await permission.status;

  if (status.isDenied) {
    status = await permission.request();
  }

  if (status.isLimited || status.isGranted) return;

  throw PermissionDeniedException(permission);
}
