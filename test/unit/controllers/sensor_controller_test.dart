import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:backbase_sesnosr_app/core/platform/interfaces/sensor_service_interface.dart';
import 'package:backbase_sesnosr_app/features/sensor/presentation/sensor_controller.dart';

import 'sensor_controller_test.mocks.dart';

@GenerateMocks([SensorServiceInterface])
void main() {
  group('SensorController', () {
    late MockSensorServiceInterface mockSensorService;
    late SensorController controller;
    late StreamController<Map<String, double>> gyroscopeStreamController;

    setUp(() {
      mockSensorService = MockSensorServiceInterface();
      controller = SensorController(mockSensorService);
      gyroscopeStreamController = StreamController<Map<String, double>>();
    });

    tearDown(() {
      gyroscopeStreamController.close();
    });

    test('should initialize with correct initial state', () {
      // Assert
      expect(controller.isFlashlightOn, isFalse);
      expect(controller.gyroscopeData, isNull);
      expect(controller.isGyroscopeActive, isFalse);
      expect(controller.gyroscopeError, isNull);
    });

    test('should toggle flashlight successfully', () async {
      // Arrange
      when(mockSensorService.toggleFlashlight(true)).thenAnswer((_) async {});

      // Act
      await controller.toggleFlashlight();

      // Assert
      expect(controller.isFlashlightOn, isTrue);
      expect(controller.gyroscopeError, isNull);
      verify(mockSensorService.toggleFlashlight(true)).called(1);
    });

    test('should toggle flashlight off successfully', () async {
      // Arrange - First turn on
      when(mockSensorService.toggleFlashlight(true)).thenAnswer((_) async {});
      await controller.toggleFlashlight();
      expect(controller.isFlashlightOn, isTrue);

      // Arrange - Then turn off
      when(mockSensorService.toggleFlashlight(false)).thenAnswer((_) async {});

      // Act
      await controller.toggleFlashlight();

      // Assert
      expect(controller.isFlashlightOn, isFalse);
      expect(controller.gyroscopeError, isNull);
      verify(mockSensorService.toggleFlashlight(false)).called(1);
    });

    test('should handle flashlight toggle error', () async {
      // Arrange
      const errorMessage = 'Flashlight not available';
      when(mockSensorService.toggleFlashlight(true)).thenThrow(Exception(errorMessage));

      // Act
      try {
        await controller.toggleFlashlight();
        fail('Should have thrown an exception');
      } catch (e) {
        // Assert
        expect(controller.isFlashlightOn, isFalse);
        expect(controller.gyroscopeError, contains(errorMessage));
      }
    });

    test('should start gyroscope successfully', () {
      // Arrange
      when(mockSensorService.gyroscopeEvents).thenAnswer((_) => gyroscopeStreamController.stream);

      // Act
      controller.startGyroscope();

      // Assert
      expect(controller.isGyroscopeActive, isTrue);
      expect(controller.gyroscopeError, isNull);
      verify(mockSensorService.gyroscopeEvents).called(1);
    });

    test('should not start gyroscope if already active', () {
      // Arrange
      when(mockSensorService.gyroscopeEvents).thenAnswer((_) => gyroscopeStreamController.stream);
      controller.startGyroscope();
      expect(controller.isGyroscopeActive, isTrue);

      // Act
      controller.startGyroscope();

      // Assert - Should not call the service again
      verify(mockSensorService.gyroscopeEvents).called(1);
    });

    test('should receive gyroscope data', () async {
      // Arrange
      when(mockSensorService.gyroscopeEvents).thenAnswer((_) => gyroscopeStreamController.stream);
      controller.startGyroscope();

      const testData = {'x': 1.5, 'y': 2.3, 'z': 0.8};

      // Act
      gyroscopeStreamController.add(testData);
      
      // Wait for the stream to be processed
      await Future.delayed(Duration(milliseconds: 10));

      // Assert
      expect(controller.gyroscopeData, isNotNull);
      expect(controller.gyroscopeData!.x, equals(1.5));
      expect(controller.gyroscopeData!.y, equals(2.3));
      expect(controller.gyroscopeData!.z, equals(0.8));
    });

    test('should handle gyroscope error', () async {
      // Arrange
      when(mockSensorService.gyroscopeEvents).thenAnswer((_) => gyroscopeStreamController.stream);
      controller.startGyroscope();

      const errorMessage = 'Gyroscope not available';

      // Act
      gyroscopeStreamController.addError(errorMessage);
      
      // Wait for the error to be processed
      await Future.delayed(Duration(milliseconds: 10));

      // Assert
      expect(controller.isGyroscopeActive, isFalse);
      expect(controller.gyroscopeError, contains(errorMessage));
    });

    test('should stop gyroscope successfully', () {
      // Arrange
      when(mockSensorService.gyroscopeEvents).thenAnswer((_) => gyroscopeStreamController.stream);
      controller.startGyroscope();
      expect(controller.isGyroscopeActive, isTrue);

      // Act
      controller.stopGyroscope();

      // Assert
      expect(controller.isGyroscopeActive, isFalse);
    });

    test('should dispose properly', () {
      // Arrange
      when(mockSensorService.gyroscopeEvents).thenAnswer((_) => gyroscopeStreamController.stream);
      controller.startGyroscope();

      // Act
      controller.dispose();

      // Assert
      expect(controller.isGyroscopeActive, isFalse);
    });
  });
} 