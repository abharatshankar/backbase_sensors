import UIKit
import Flutter
import AVFoundation
import CoreMotion

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let DEVICE_CHANNEL = "com.example.device_info/device"
    private let SENSOR_CHANNEL = "com.example.device_info/sensors"
    private let SENSOR_EVENT_CHANNEL = "com.example.device_info/sensor_stream"
    
    private let motionManager = CMMotionManager()
    private weak var flutterController: FlutterViewController?
    
    // For EventChannel streaming
    private var sensorEventChannel: FlutterEventChannel?
    private var sensorEventSink: FlutterEventSink?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("Root controller is not a FlutterViewController")
        }
        flutterController = controller
        
        setupMethodChannels(controller: controller)
        setupEventChannel(controller: controller)
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupMethodChannels(controller: FlutterViewController) {
        let deviceChannel = FlutterMethodChannel(
            name: DEVICE_CHANNEL,
            binaryMessenger: controller.binaryMessenger
        )
        
        deviceChannel.setMethodCallHandler { [weak self] (call, result) in
            self?.handleDeviceMethodCall(call: call, result: result)
        }
        
        let sensorChannel = FlutterMethodChannel(
            name: SENSOR_CHANNEL,
            binaryMessenger: controller.binaryMessenger
        )
        
        sensorChannel.setMethodCallHandler { [weak self] (call, result) in
            self?.handleSensorMethodCall(call: call, result: result)
        }
    }
    
    private func setupEventChannel(controller: FlutterViewController) {
        sensorEventChannel = FlutterEventChannel(
            name: SENSOR_EVENT_CHANNEL,
            binaryMessenger: controller.binaryMessenger
        )
        sensorEventChannel?.setStreamHandler(self)
    }
    
    // MARK: - Method Channel Handlers
    
    private func handleDeviceMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getDeviceName":
            result(getDeviceName())
        case "getOSVersion":
            result(getOSVersion())
        case "getBatteryLevel":
            getBatteryLevel(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleSensorMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "toggleFlashlight":
            let arguments = call.arguments as? [String: Any]
            let status = arguments?["status"] as? Bool ?? false
            toggleFlashlight(status: status, result: result)
        case "getGyroscopeData":
            getGyroscopeData(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Device Info Methods
    
    private func getDeviceName() -> String {
        return UIDevice.current.name
    }
    
    private func getOSVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    private func getBatteryLevel(result: FlutterResult) {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel
        if level < 0 {
            result(FlutterError(code: "UNAVAILABLE", message: "Battery level not available", details: nil))
        } else {
            result(Int(level * 100))
        }
    }
    
    // MARK: - Flashlight Control
    
    private func toggleFlashlight(status: Bool, result: FlutterResult) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            result(FlutterError(code: "UNAVAILABLE", message: "Flashlight not available", details: nil))
            return
        }
        do {
            try device.lockForConfiguration()
            device.torchMode = status ? .on : .off
            device.unlockForConfiguration()
            result(nil)
        } catch {
            result(FlutterError(code: "ERROR", message: "Failed to toggle flashlight", details: error.localizedDescription))
        }
    }
    
    // MARK: - One-shot Gyroscope Data
    
    private func getGyroscopeData(result: @escaping FlutterResult) {
        guard motionManager.isGyroAvailable else {
            result(FlutterError(code: "UNAVAILABLE", message: "Gyroscope not available", details: nil))
            return
        }
        
        motionManager.gyroUpdateInterval = 0.1
        motionManager.startGyroUpdates()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let data = self.motionManager.gyroData {
                let gyroDict = [
                    "x": data.rotationRate.x,
                    "y": data.rotationRate.y,
                    "z": data.rotationRate.z
                ]
                result(gyroDict)
            } else {
                result(FlutterError(code: "NODATA", message: "No gyro data available", details: nil))
            }
            self.motionManager.stopGyroUpdates()
        }
    }
    
    // MARK: - Lifecycle management for gyroscope
    
    override func applicationWillResignActive(_ application: UIApplication) {
        motionManager.stopGyroUpdates()
        sensorEventSink = nil
    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        // No automatic restart for streaming here — handled by event channel listener
    }
}

// MARK: - FlutterStreamHandler for continuous gyroscope streaming

extension AppDelegate: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sensorEventSink = events
        
        guard motionManager.isGyroAvailable else {
            return FlutterError(code: "UNAVAILABLE", message: "Gyroscope not available", details: nil)
        }
        
        motionManager.gyroUpdateInterval = 0.1
        motionManager.startGyroUpdates(to: .main) { [weak self] (data, error) in
            if let error = error {
                self?.sensorEventSink?(FlutterError(code: "GYRO_ERROR", message: error.localizedDescription, details: nil))
                return
            }
            if let data = data {
                let gyroDict: [String: Double] = [
                    "x": data.rotationRate.x,
                    "y": data.rotationRate.y,
                    "z": data.rotationRate.z
                ]
                self?.sensorEventSink?(gyroDict)
            }
        }
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopGyroUpdates()
        sensorEventSink = nil
        return nil
    }
}
