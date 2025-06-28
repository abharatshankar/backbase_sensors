import 'dart:async';
import 'package:backbase_sesnosr_app/core/platform/interfaces/sensor_service_interface.dart';
import 'package:flutter/foundation.dart';
import '../domain/models/sensor_data.dart';

class SensorController with ChangeNotifier {
  final SensorServiceInterface _sensorService;

  bool _isFlashlightOn = false;
  SensorData? _gyroscopeData;
  bool _isGyroscopeActive = false;
  String? _gyroscopeError;
  StreamSubscription<Map<String, double>>? _gyroSubscription;

  bool get isFlashlightOn => _isFlashlightOn;
  SensorData? get gyroscopeData => _gyroscopeData;
  bool get isGyroscopeActive => _isGyroscopeActive;
  String? get gyroscopeError => _gyroscopeError;

  SensorController(this._sensorService);

  Future<void> toggleFlashlight() async {
    try {
      await _sensorService.toggleFlashlight(!_isFlashlightOn);
      _isFlashlightOn = !_isFlashlightOn;
      _gyroscopeError = null;
      notifyListeners();
    } catch (e) {
      _gyroscopeError = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void startGyroscope() {
    if (_isGyroscopeActive) return;

    _isGyroscopeActive = true;
    _gyroscopeError = null;
    notifyListeners();

    _gyroSubscription = _sensorService.gyroscopeEvents.listen(
      (data) {
        _gyroscopeData = SensorData(
          x: data['x'] ?? 0,
          y: data['y'] ?? 0,
          z: data['z'] ?? 0,
        );
        notifyListeners();
      },
      onError: (error) {
        _gyroscopeError = error.toString();
        _isGyroscopeActive = false;
        notifyListeners();
      },
      cancelOnError: true,
    );
  }

  void stopGyroscope() {
    _gyroSubscription?.cancel();
    _gyroSubscription = null;
    _isGyroscopeActive = false;
    notifyListeners();
  }

  @override
  void dispose() {
    stopGyroscope();
    super.dispose();
  }
}
