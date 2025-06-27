import 'package:backbase_sesnosr_app/features/sensor/presentation/sensor_controller.dart';
import 'package:backbase_sesnosr_app/features/sensor/presentation/widgets/sensor_card.dart';
import 'package:backbase_sesnosr_app/features/sensor/presentation/widgets/toogle_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key});

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Controls'),
      ),
      body: Consumer<SensorController>(
        builder: (context, controller, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SensorCard(
                  icon: Icons.lightbulb,
                  title: 'Flashlight',
                  child: ToggleButton(
                    value: controller.isFlashlightOn,
                    onChanged: (_) => controller.toggleFlashlight(),
                    activeIcon: Icons.flash_on,
                    inactiveIcon: Icons.flash_off,
                  ),
                ),
                const SizedBox(height: 16),
                SensorCard(
                  icon: Icons.graphic_eq,
                  title: 'Gyroscope',
                  child: Column(
                    children: [
                      if (controller.gyroscopeData != null) ...[
                        Text(
                          'X: ${controller.gyroscopeData!.x.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Y: ${controller.gyroscopeData!.y.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Z: ${controller.gyroscopeData!.z.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.isGyroscopeActive
                            ? controller.stopGyroscope
                            : controller.startGyroscope,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isGyroscopeActive
                              ? Colors.red
                              : Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          controller.isGyroscopeActive
                              ? 'Stop Gyroscope'
                              : 'Start Gyroscope',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}