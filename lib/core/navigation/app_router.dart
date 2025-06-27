import 'package:backbase_sesnosr_app/features/dashboard/presentation/dashboard_screen.dart';
import 'package:backbase_sesnosr_app/features/sensor/presentation/sensor_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String dashboard = '/';
  static const String sensor = '/sensor';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case sensor:
        return MaterialPageRoute(builder: (_) => const SensorScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}