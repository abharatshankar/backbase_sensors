import 'package:backbase_sesnosr_app/features/dashboard/domain/models/device_info.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
              BatteryLottieAnimation(
                batteryPercentage: deviceInfo.batteryLevel,
              ),
              Text( ' ${deviceInfo.batteryLevel}%', style: TextStyle(fontSize: 36)),
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



class BatteryLottieAnimation extends StatefulWidget {
  final int batteryPercentage; // 0 to 100

  const BatteryLottieAnimation({super.key, required this.batteryPercentage});

  @override
  State<BatteryLottieAnimation> createState() => _BatteryLottieAnimationState();
}

class _BatteryLottieAnimationState extends State<BatteryLottieAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _showAnimation = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    
    if (mounted) {
      setState(() {
        _showAnimation = true;
      });
    }
  }

  @override
  void didUpdateWidget(covariant BatteryLottieAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.batteryPercentage != widget.batteryPercentage) {
      _setProgress();
    }
  }

  void _setProgress() {
    if (!_showAnimation) return;
    
    final progress = (widget.batteryPercentage.clamp(0, 100)) / 100;
    _controller.animateTo(progress, duration: const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showAnimation) {
      return const SizedBox(height: 120);
    }

    return SizedBox(
      height: 120,
      child: Lottie.asset(
        'assets/battery_animation.json',
        controller: _controller,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
          _setProgress(); // Set initial progress after composition is loaded
        },
        fit: BoxFit.contain,
        animate: false, // Disable auto-animation
      ),
    );
  }
}