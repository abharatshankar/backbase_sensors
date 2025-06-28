import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:backbase_sesnosr_app/core/platform/interfaces/device_info_service_interface.dart';
import 'package:backbase_sesnosr_app/features/dashboard/presentation/dashboard_controller.dart';
import 'package:backbase_sesnosr_app/features/dashboard/domain/models/device_info.dart';

import 'dashboard_controller_test.mocks.dart';

@GenerateMocks([DeviceInfoServiceInterface])
void main() {
  group('DashboardController', () {
    late MockDeviceInfoServiceInterface mockDeviceInfoService;
    late DashboardController controller;

    setUp(() {
      mockDeviceInfoService = MockDeviceInfoServiceInterface();
      controller = DashboardController(mockDeviceInfoService);
    });

    test('should initialize with correct initial state', () {
      // Assert
      expect(controller.deviceInfo, isNull);
      expect(controller.isLoading, isFalse);
      expect(controller.error, isNull);
    });

    test('should fetch device info successfully', () async {
      // Arrange
      const deviceName = 'iPhone 15';
      const osVersion = 'iOS 17.0';
      const batteryLevel = 85;

      when(mockDeviceInfoService.getDeviceName()).thenAnswer((_) async => deviceName);
      when(mockDeviceInfoService.getOSVersion()).thenAnswer((_) async => osVersion);
      when(mockDeviceInfoService.getBatteryLevel()).thenAnswer((_) async => batteryLevel);

      // Act
      await controller.fetchDeviceInfo();

      // Assert
      expect(controller.deviceInfo, isNotNull);
      expect(controller.deviceInfo!.deviceName, equals(deviceName));
      expect(controller.deviceInfo!.osVersion, equals(osVersion));
      expect(controller.deviceInfo!.batteryLevel, equals(batteryLevel));
      expect(controller.isLoading, isFalse);
      expect(controller.error, isNull);

      verify(mockDeviceInfoService.getDeviceName()).called(1);
      verify(mockDeviceInfoService.getOSVersion()).called(1);
      verify(mockDeviceInfoService.getBatteryLevel()).called(1);
    });

    test('should handle error when fetching device info fails', () async {
      // Arrange
      const errorMessage = 'Failed to get device info';
      when(mockDeviceInfoService.getDeviceName()).thenThrow(Exception(errorMessage));

      // Act
      await controller.fetchDeviceInfo();

      // Assert
      expect(controller.deviceInfo, isNull);
      expect(controller.isLoading, isFalse);
      expect(controller.error, contains(errorMessage));
    });

    test('should set loading state during fetch', () async {
      // Arrange
      when(mockDeviceInfoService.getDeviceName()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return 'Test Device';
      });
      when(mockDeviceInfoService.getOSVersion()).thenAnswer((_) async => 'Test OS');
      when(mockDeviceInfoService.getBatteryLevel()).thenAnswer((_) async => 50);

      // Act
      final future = controller.fetchDeviceInfo();
      
      // Assert - should be loading initially
      expect(controller.isLoading, isTrue);
      
      // Wait for completion
      await future;
      
      // Assert - should not be loading after completion
      expect(controller.isLoading, isFalse);
    });

    test('should clear error when fetch succeeds after previous error', () async {
      // Arrange - First call fails
      when(mockDeviceInfoService.getDeviceName()).thenThrow(Exception('First error'));
      await controller.fetchDeviceInfo();
      expect(controller.error, isNotNull);

      // Arrange - Second call succeeds
      when(mockDeviceInfoService.getDeviceName()).thenAnswer((_) async => 'Test Device');
      when(mockDeviceInfoService.getOSVersion()).thenAnswer((_) async => 'Test OS');
      when(mockDeviceInfoService.getBatteryLevel()).thenAnswer((_) async => 50);

      // Act
      await controller.fetchDeviceInfo();

      // Assert
      expect(controller.error, isNull);
      expect(controller.deviceInfo, isNotNull);
    });
  });
} 