import 'package:backbase_sesnosr_app/core/platform/interfaces/device_info_service_interface.dart';
import 'package:backbase_sesnosr_app/features/dashboard/domain/models/device_info.dart';
import 'package:flutter/material.dart';

class DashboardController with ChangeNotifier {
  final DeviceInfoServiceInterface _deviceInfoService;
  DeviceInfo? _deviceInfo;
  bool _isLoading = false;
  String? _error;

  DeviceInfo? get deviceInfo => _deviceInfo;
  bool get isLoading => _isLoading;
  String? get error => _error;

  DashboardController(this._deviceInfoService);

  Future<void> fetchDeviceInfo() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final deviceName = await _deviceInfoService.getDeviceName();
      final osVersion = await _deviceInfoService.getOSVersion();
      final batteryLevel = await _deviceInfoService.getBatteryLevel();

      _deviceInfo = DeviceInfo(
        deviceName: deviceName,
        osVersion: osVersion,
        batteryLevel: batteryLevel,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}