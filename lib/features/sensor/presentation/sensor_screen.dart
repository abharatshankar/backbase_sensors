import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:backbase_sesnosr_app/features/sensor/presentation/sensor_controller.dart';
import 'package:backbase_sesnosr_app/features/sensor/presentation/widgets/toogle_button.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key});

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Sensor Controls',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<SensorController>(
              builder: (context, controller, child) {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    GlassCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb, color: Colors.amber, size: 32),
                              const SizedBox(width: 12),
                              Text(
                                'Flashlight',
                                style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                          ToggleButton(
                            value: controller.isFlashlightOn,
                            onChanged: (_) => controller.toggleFlashlight(),
                            activeIcon: Icons.flash_on,
                            inactiveIcon: Icons.flash_off,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.graphic_eq, color: Colors.lightBlueAccent, size: 32),
                              const SizedBox(width: 12),
                              Text(
                                'Gyroscope',
                                style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (controller.gyroscopeData != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SensorDataText(label: 'X', value: controller.gyroscopeData!.x),
                                SensorDataText(label: 'Y', value: controller.gyroscopeData!.y),
                                SensorDataText(label: 'Z', value: controller.gyroscopeData!.z),
                              ],
                            )
                          else
                            Text(
                              'No data yet',
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white54),
                            ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: controller.isGyroscopeActive
                                  ? controller.stopGyroscope
                                  : controller.startGyroscope,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: controller.isGyroscopeActive ? Colors.redAccent : Colors.lightBlueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                                elevation: 6,
                                shadowColor: controller.isGyroscopeActive ? Colors.redAccent.withOpacity(0.6) : Colors.lightBlueAccent.withOpacity(0.6),
                              ),
                              child: Text(
                                controller.isGyroscopeActive ? 'Stop Gyroscope' : 'Start Gyroscope',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;

  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: child,
        ),
      ),
    );
  }
}

class SensorDataText extends StatelessWidget {
  final String label;
  final double value;

  const SensorDataText({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label: ${value.toStringAsFixed(3)}',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
    );
  }
}
