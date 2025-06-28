import 'dart:async';
import 'package:flutter/services.dart';
import 'interfaces/sensor_service_interface.dart';

class SensorService implements SensorServiceInterface {
  static const MethodChannel _methodChannel = MethodChannel('com.example.device_info/sensors');
  static const EventChannel _gyroEventChannel = EventChannel('com.example.device_info/sensor_stream');

  @override
  Future<void> toggleFlashlight(bool status) async {
    try {
      await _methodChannel.invokeMethod('toggleFlashlight', {'status': status});
    } on PlatformException catch (e) {
      throw Exception("Failed to toggle flashlight: ${e.message}");
    }
  }

  @override
  // Continuous stream of gyro data
  Stream<Map<String, double>> get gyroscopeEvents {
    return _gyroEventChannel.receiveBroadcastStream().map((event) {
      final map = Map<String, dynamic>.from(event);
      return {
        'x': (map['x'] as num).toDouble(),
        'y': (map['y'] as num).toDouble(),
        'z': (map['z'] as num).toDouble(),
      };
    });
  }
}
