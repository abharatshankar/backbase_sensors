import 'package:backbase_sesnosr_app/core/di/controller_factory.dart';
import 'package:backbase_sesnosr_app/core/di/service_locator.dart';
import 'package:backbase_sesnosr_app/core/navigation/app_router.dart';
import 'package:backbase_sesnosr_app/core/platform/interfaces/device_info_service_interface.dart';
import 'package:backbase_sesnosr_app/core/platform/interfaces/sensor_service_interface.dart';
import 'package:backbase_sesnosr_app/features/dashboard/presentation/dashboard_controller.dart';
import 'package:backbase_sesnosr_app/features/sensor/presentation/sensor_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize service locator
    final serviceLocator = ServiceLocator();
    serviceLocator.registerServices();

    // Create controller factory
    final controllerFactory = ControllerFactory(serviceLocator);

    return MultiProvider(
      providers: [
        Provider<DeviceInfoServiceInterface>(
          create: (_) => serviceLocator.get<DeviceInfoServiceInterface>(),
        ),
        Provider<SensorServiceInterface>(
          create: (_) => serviceLocator.get<SensorServiceInterface>(),
        ),
        Provider<ControllerFactory>(
          create: (_) => controllerFactory,
        ),
        ChangeNotifierProxyProvider<DeviceInfoServiceInterface, DashboardController>(
          create: (context) => controllerFactory.createDashboardController(),
          update: (context, deviceInfoService, controller) => 
              controller ?? controllerFactory.createDashboardController(),
        ),
        ChangeNotifierProxyProvider<SensorServiceInterface, SensorController>(
          create: (context) => controllerFactory.createSensorController(),
          update: (context, sensorService, controller) => 
              controller ?? controllerFactory.createSensorController(),
        ),
      ],
      child: MaterialApp(
        title: 'Device Info & Sensors',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.dashboard,
      ),
    );
  }
}