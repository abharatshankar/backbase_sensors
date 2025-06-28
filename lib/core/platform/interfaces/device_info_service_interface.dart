abstract class DeviceInfoServiceInterface {
  Future<String> getDeviceName();
  Future<String> getOSVersion();
  Future<int> getBatteryLevel();
} 