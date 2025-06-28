import 'package:backbase_sesnosr_app/core/di/service_locator.dart';
import 'package:backbase_sesnosr_app/core/platform/interfaces/device_info_service_interface.dart';
import 'package:backbase_sesnosr_app/core/platform/interfaces/sensor_service_interface.dart';

class TestServiceLocator {
  static ServiceLocator createWithMocks({
    DeviceInfoServiceInterface? deviceInfoService,
    SensorServiceInterface? sensorService,
  }) {
    final serviceLocator = ServiceLocator();
    serviceLocator.reset();
    
    if (deviceInfoService != null) {
      serviceLocator.register<DeviceInfoServiceInterface>(deviceInfoService);
    }
    
    if (sensorService != null) {
      serviceLocator.register<SensorServiceInterface>(sensorService);
    }
    
    return serviceLocator;
  }
} 