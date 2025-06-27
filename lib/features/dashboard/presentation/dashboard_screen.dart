import 'package:backbase_sesnosr_app/features/dashboard/presentation/dashboard_controller.dart';
import 'package:backbase_sesnosr_app/features/dashboard/presentation/widgets/device_info_card.dart';
import 'package:backbase_sesnosr_app/features/dashboard/presentation/widgets/loading_animation.dart';
import 'package:backbase_sesnosr_app/features/sensor/presentation/sensor_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().fetchDeviceInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sensors),  // Sensor icon
            onPressed: () {
              // Navigate to SensorScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SensorScreen()),
              );
              
              // If using named routes:
              // Navigator.pushNamed(context, AppRouter.sensor);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DashboardController>().fetchDeviceInfo();
            },
          ),
        ],
      ),
      body: Consumer<DashboardController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: LoadingAnimation());
          }

          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${controller.error}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.fetchDeviceInfo,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.deviceInfo == null) {
            return const Center(child: Text('No device info available'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                DeviceInfoCard(deviceInfo: controller.deviceInfo!),
              ],
            ),
          );
        },
      ),
    );
  }
}