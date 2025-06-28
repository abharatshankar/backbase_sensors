import 'package:flutter_test/flutter_test.dart';
import 'package:backbase_sesnosr_app/features/sensor/domain/models/sensor_data.dart';

void main() {
  group('SensorData', () {
    test('should create SensorData with correct properties', () {
      // Arrange
      const x = 1.5;
      const y = 2.3;
      const z = 0.8;

      // Act
      final sensorData = SensorData(x: x, y: y, z: z);

      // Assert
      expect(sensorData.x, equals(x));
      expect(sensorData.y, equals(y));
      expect(sensorData.z, equals(z));
    });

    test('should create SensorData with zero values', () {
      // Arrange & Act
      final sensorData = SensorData(x: 0.0, y: 0.0, z: 0.0);

      // Assert
      expect(sensorData.x, equals(0.0));
      expect(sensorData.y, equals(0.0));
      expect(sensorData.z, equals(0.0));
    });

    test('should create SensorData with negative values', () {
      // Arrange
      const x = -1.5;
      const y = -2.3;
      const z = -0.8;

      // Act
      final sensorData = SensorData(x: x, y: y, z: z);

      // Assert
      expect(sensorData.x, equals(x));
      expect(sensorData.y, equals(y));
      expect(sensorData.z, equals(z));
    });

    test('should create SensorData with large values', () {
      // Arrange
      const x = 999.999;
      const y = 888.888;
      const z = 777.777;

      // Act
      final sensorData = SensorData(x: x, y: y, z: z);

      // Assert
      expect(sensorData.x, equals(x));
      expect(sensorData.y, equals(y));
      expect(sensorData.z, equals(z));
    });
  });
} 