import 'package:flutter_test/flutter_test.dart';
import 'package:backbase_sesnosr_app/features/dashboard/domain/models/device_info.dart';

void main() {
  group('DeviceInfo', () {
    test('should create DeviceInfo with correct properties', () {
      // Arrange
      const deviceName = 'iPhone 15';
      const osVersion = 'iOS 17.0';
      const batteryLevel = 85;

      // Act
      final deviceInfo = DeviceInfo(
        deviceName: deviceName,
        osVersion: osVersion,
        batteryLevel: batteryLevel,
      );

      // Assert
      expect(deviceInfo.deviceName, equals(deviceName));
      expect(deviceInfo.osVersion, equals(osVersion));
      expect(deviceInfo.batteryLevel, equals(batteryLevel));
    });

    test('should create DeviceInfo with zero battery level', () {
      // Arrange & Act
      final deviceInfo = DeviceInfo(
        deviceName: 'Test Device',
        osVersion: 'Test OS',
        batteryLevel: 0,
      );

      // Assert
      expect(deviceInfo.batteryLevel, equals(0));
    });

    test('should create DeviceInfo with full battery level', () {
      // Arrange & Act
      final deviceInfo = DeviceInfo(
        deviceName: 'Test Device',
        osVersion: 'Test OS',
        batteryLevel: 100,
      );

      // Assert
      expect(deviceInfo.batteryLevel, equals(100));
    });

    test('should create DeviceInfo with empty strings', () {
      // Arrange & Act
      final deviceInfo = DeviceInfo(
        deviceName: '',
        osVersion: '',
        batteryLevel: 50,
      );

      // Assert
      expect(deviceInfo.deviceName, isEmpty);
      expect(deviceInfo.osVersion, isEmpty);
      expect(deviceInfo.batteryLevel, equals(50));
    });
  });
} 