import 'package:backbase_sesnosr_app/core/di/service_locator.dart';
import 'package:backbase_sesnosr_app/core/platform/interfaces/device_info_service_interface.dart';
import 'package:backbase_sesnosr_app/core/platform/interfaces/sensor_service_interface.dart';
import 'package:backbase_sesnosr_app/features/dashboard/presentation/dashboard_controller.dart';
import 'package:backbase_sesnosr_app/features/sensor/presentation/sensor_controller.dart';

class ControllerFactory {
  final ServiceLocator _serviceLocator;

  ControllerFactory(this._serviceLocator);

  DashboardController createDashboardController() {
    return DashboardController(_serviceLocator.get<DeviceInfoServiceInterface>());
  }

  SensorController createSensorController() {
    return SensorController(_serviceLocator.get<SensorServiceInterface>());
  }
} 