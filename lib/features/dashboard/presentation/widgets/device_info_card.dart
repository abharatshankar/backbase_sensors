import 'package:backbase_sesnosr_app/features/dashboard/domain/models/device_info.dart';
import 'package:flutter/material.dart';

class DeviceInfoCard extends StatelessWidget {
  final DeviceInfo deviceInfo;

  const DeviceInfoCard({super.key, required this.deviceInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Device Information',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.phone_android, 'Device Name', deviceInfo.deviceName),
          _buildInfoRow(Icons.android, 'OS Version', deviceInfo.osVersion),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomBatteryWidget(
                batteryPercentage: deviceInfo.batteryLevel,
              ),
              const SizedBox(width: 16),
              Text(
                '${deviceInfo.batteryLevel}%',
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Widget? extra}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(value),
            ],
          ),
          if (extra != null) ...[
            const SizedBox(height: 4),
            extra,
          ]
        ],
      ),
    );
  }
}

class CustomBatteryWidget extends StatefulWidget {
  final int batteryPercentage;

  const CustomBatteryWidget({super.key, required this.batteryPercentage});

  @override
  State<CustomBatteryWidget> createState() => _CustomBatteryWidgetState();
}

class _CustomBatteryWidgetState extends State<CustomBatteryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // Initialize the animation with the current battery percentage
    final initialValue = widget.batteryPercentage / 100.0;
    _fillAnimation = Tween<double>(
      begin: 0.0,
      end: initialValue,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void didUpdateWidget(CustomBatteryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.batteryPercentage != widget.batteryPercentage) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    final targetValue = widget.batteryPercentage / 100.0;
    _fillAnimation = Tween<double>(
      begin: _fillAnimation.value,
      end: targetValue,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getBatteryColor(double percentage) {
    if (percentage <= 0.2) return Colors.red;
    if (percentage <= 0.4) return Colors.orange;
    if (percentage <= 0.6) return Colors.yellow;
    if (percentage <= 0.8) return Colors.lightGreen;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fillAnimation,
      builder: (context, child) {
        final fillPercentage = _fillAnimation.value;
        final batteryColor = _getBatteryColor(fillPercentage);
        
        return Container(
          width: 80,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade600, width: 3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // Battery fill
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120 * fillPercentage,
                  decoration: BoxDecoration(
                    color: batteryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                ),
              ),
              // Battery terminal
              Positioned(
                top: -8,
                left: 50,
                child: Container(
                  width: 20,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}