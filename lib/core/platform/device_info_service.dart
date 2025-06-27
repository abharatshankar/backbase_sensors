import 'package:flutter/services.dart';

class DeviceInfoService {
  static const platform = MethodChannel('com.example.device_info/device');

  Future<String> getDeviceName() async {
    try {
      return await platform.invokeMethod('getDeviceName');
    } on PlatformException catch (e) {
      return "Unknown (${e.message})";
    }
  }

  Future<String> getOSVersion() async {
    try {
      return await platform.invokeMethod('getOSVersion');
    } on PlatformException catch (e) {
      return "Unknown (${e.message})";
    }
  }

  Future<int> getBatteryLevel() async {
    try {
      return await platform.invokeMethod('getBatteryLevel');
    } on PlatformException catch (e) {
      return -1;
    }
  }
}