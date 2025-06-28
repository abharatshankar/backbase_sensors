import 'package:flutter_test/flutter_test.dart';
import 'package:backbase_sesnosr_app/core/di/controller_factory.dart';
import 'package:backbase_sesnosr_app/core/di/service_locator.dart';
import 'package:backbase_sesnosr_app/features/dashboard/presentation/dashboard_controller.dart';
import 'package:backbase_sesnosr_app/features/sensor/presentation/sensor_controller.dart';
import '../../helpers/test_service_locator.dart';
import '../controllers/dashboard_controller_test.mocks.dart';
import '../controllers/sensor_controller_test.mocks.dart';

void main() {
  group('ControllerFactory', () {
    late MockDeviceInfoServiceInterface mockDeviceInfoService;
    late MockSensorServiceInterface mockSensorService;
    late ServiceLocator serviceLocator;
    late ControllerFactory factory;

    setUp(() {
      mockDeviceInfoService = MockDeviceInfoServiceInterface();
      mockSensorService = MockSensorServiceInterface();
      
      serviceLocator = TestServiceLocator.createWithMocks(
        deviceInfoService: mockDeviceInfoService,
        sensorService: mockSensorService,
      );
      
      factory = ControllerFactory(serviceLocator);
    });

    test('should create DashboardController with injected service', () {
      // Act
      final controller = factory.createDashboardController();

      // Assert
      expect(controller, isA<DashboardController>());
    });

    test('should create SensorController with injected service', () {
      // Act
      final controller = factory.createSensorController();

      // Assert
      expect(controller, isA<SensorController>());
    });

    test('should create different instances of controllers', () {
      // Act
      final controller1 = factory.createDashboardController();
      final controller2 = factory.createDashboardController();

      // Assert
      expect(controller1, isNot(same(controller2)));
    });

    test('should work with real service implementations', () {
      // Arrange
      final realServiceLocator = ServiceLocator();
      realServiceLocator.registerServices();
      final realFactory = ControllerFactory(realServiceLocator);

      // Act
      final dashboardController = realFactory.createDashboardController();
      final sensorController = realFactory.createSensorController();

      // Assert
      expect(dashboardController, isA<DashboardController>());
      expect(sensorController, isA<SensorController>());
    });
  });
} 