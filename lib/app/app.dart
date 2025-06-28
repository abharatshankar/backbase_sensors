import 'package:backbase_sesnosr_app/core/navigation/app_router.dart';
import 'package:backbase_sesnosr_app/core/platform/device_info_service.dart';
import 'package:backbase_sesnosr_app/core/platform/sensor_service.dart';
import 'package:backbase_sesnosr_app/features/dashboard/presentation/dashboard_controller.dart';
import 'package:backbase_sesnosr_app/features/sensor/presentation/sensor_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => DeviceInfoService()),
        Provider(create: (_) => SensorService()),
        ChangeNotifierProxyProvider<DeviceInfoService, DashboardController>(
          create: (context) => DashboardController(context.read<DeviceInfoService>()),
          update: (context, deviceInfoService, controller) => 
              controller ?? DashboardController(deviceInfoService),
        ),
        ChangeNotifierProxyProvider<SensorService, SensorController>(
          create: (context) => SensorController(context.read<SensorService>()),
          update: (context, sensorService, controller) => 
              controller ?? SensorController(sensorService),
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