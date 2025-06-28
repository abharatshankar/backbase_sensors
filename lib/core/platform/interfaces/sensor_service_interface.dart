import 'dart:async';

abstract class SensorServiceInterface {
  Future<void> toggleFlashlight(bool isOn);
  Stream<Map<String, double>> get gyroscopeEvents;
} 