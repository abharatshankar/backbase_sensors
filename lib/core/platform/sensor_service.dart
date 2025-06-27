import 'dart:async';
import 'package:flutter/services.dart';

class SensorService {
  static const MethodChannel _methodChannel = MethodChannel('com.example.device_info/sensors');
  static const EventChannel _gyroEventChannel = EventChannel('com.example.device_info/sensor_stream');

  Future<void> toggleFlashlight(bool status) async {
    try {
      await _methodChannel.invokeMethod('toggleFlashlight', {'status': status});
    } on PlatformException catch (e) {
      throw Exception("Failed to toggle flashlight: ${e.message}");
    }
  }

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
