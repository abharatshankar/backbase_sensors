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
          _buildInfoRow(
            Icons.battery_std,
            'Battery Level',
            '${deviceInfo.batteryLevel}%',
            extra: LinearProgressIndicator(
              value: deviceInfo.batteryLevel / 100,
              backgroundColor: Colors.grey.shade300,
              color: _getBatteryColor(deviceInfo.batteryLevel),
            ),
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

  Color _getBatteryColor(int level) {
    if (level > 70) return Colors.green;
    if (level > 30) return Colors.orange;
    return Colors.red;
  }
}