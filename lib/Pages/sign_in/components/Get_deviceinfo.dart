import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

Future<Map<String, dynamic>> getDeviceInfo() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};

  try {
    if (!kIsWeb) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          deviceData =
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
          break;
        case TargetPlatform.iOS:
          deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
          break;
        default:
          deviceData = <String, dynamic>{'Error:': 'Platform not supported'};
      }
    }
  } catch (e) {
    deviceData = <String, dynamic>{'Error:': 'Failed to get device info'};
  }

  return deviceData;
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'brand': build.brand,
    'device': build.device,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'model': data.model,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'macAddress': data.isPhysicalDevice,
  };
}
