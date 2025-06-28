import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:backbase_sesnosr_app/core/di/service_locator.dart';
import 'package:backbase_sesnosr_app/core/platform/interfaces/device_info_service_interface.dart';
import 'package:backbase_sesnosr_app/core/platform/interfaces/sensor_service_interface.dart';
import 'package:backbase_sesnosr_app/features/dashboard/presentation/dashboard_controller.dart';
import 'package:backbase_sesnosr_app/features/sensor/presentation/sensor_controller.dart';
import '../helpers/test_service_locator.dart';
import '../unit/controllers/dashboard_controller_test.mocks.dart';
import '../unit/controllers/sensor_controller_test.mocks.dart';

void main() {
  group('Dependency Injection Integration Tests', () {
    late MockDeviceInfoServiceInterface mockDeviceInfoService;
    late MockSensorServiceInterface mockSensorService;
    late ServiceLocator serviceLocator;

    setUp(() {
      mockDeviceInfoService = MockDeviceInfoServiceInterface();
      mockSensorService = MockSensorServiceInterface();
      
      serviceLocator = TestServiceLocator.createWithMocks(
        deviceInfoService: mockDeviceInfoService,
        sensorService: mockSensorService,
      );
    });

    test('should resolve services from service locator', () {
      // Act
      final deviceInfoService = serviceLocator.get<DeviceInfoServiceInterface>();
      final sensorService = serviceLocator.get<SensorServiceInterface>();

      // Assert
      expect(deviceInfoService, equals(mockDeviceInfoService));
      expect(sensorService, equals(mockSensorService));
    });

    test('should create controllers with injected services', () {
      // Act
      final dashboardController = DashboardController(
        serviceLocator.get<DeviceInfoServiceInterface>(),
      );
      final sensorController = SensorController(
        serviceLocator.get<SensorServiceInterface>(),
      );

      // Assert
      expect(dashboardController, isNotNull);
      expect(sensorController, isNotNull);
    });

    test('should throw exception when service not registered', () {
      // Arrange
      final emptyServiceLocator = ServiceLocator();
      emptyServiceLocator.reset();

      // Act & Assert
      expect(
        () => emptyServiceLocator.get<DeviceInfoServiceInterface>(),
        throwsException,
      );
    });

    test('should work with real service implementations', () {
      // Arrange
      final realServiceLocator = ServiceLocator();
      realServiceLocator.registerServices();

      // Act
      final deviceInfoService = realServiceLocator.get<DeviceInfoServiceInterface>();
      final sensorService = realServiceLocator.get<SensorServiceInterface>();

      // Assert
      expect(deviceInfoService, isNotNull);
      expect(sensorService, isNotNull);
    });
  });
} 