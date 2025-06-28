import 'package:backbase_sesnosr_app/core/platform/device_info_service.dart';
import 'package:backbase_sesnosr_app/core/platform/interfaces/device_info_service_interface.dart';
import 'package:backbase_sesnosr_app/core/platform/interfaces/sensor_service_interface.dart';
import 'package:backbase_sesnosr_app/core/platform/sensor_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};

  void register<T>(T service) {
    _services[T] = service;
  }

  T get<T>() {
    if (_services.containsKey(T)) {
      return _services[T] as T;
    }
    throw Exception('Service of type $T not registered');
  }

  void reset() {
    _services.clear();
  }

  void registerServices() {
    // Register concrete implementations
    register<DeviceInfoServiceInterface>(DeviceInfoService());
    register<SensorServiceInterface>(SensorService());
  }
} 