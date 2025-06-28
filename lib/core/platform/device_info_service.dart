import 'package:flutter/services.dart';
import 'interfaces/device_info_service_interface.dart';

class DeviceInfoService implements DeviceInfoServiceInterface {
  static const platform = MethodChannel('com.example.device_info/device');

  @override
  Future<String> getDeviceName() async {
    try {
      return await platform.invokeMethod('getDeviceName');
    } on PlatformException catch (e) {
      return "Unknown (${e.message})";
    }
  }

  @override
  Future<String> getOSVersion() async {
    try {
      return await platform.invokeMethod('getOSVersion');
    } on PlatformException catch (e) {
      return "Unknown (${e.message})";
    }
  }

  @override
  Future<int> getBatteryLevel() async {
    try {
      return await platform.invokeMethod('getBatteryLevel');
    } on PlatformException catch (e) {
      return -1;
    }
  }
}