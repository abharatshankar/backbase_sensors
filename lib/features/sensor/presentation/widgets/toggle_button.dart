import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  final IconData activeIcon;
  final IconData inactiveIcon;

  const ToggleButton({
    super.key,
    required this.value,
    required this.onChanged,
    required this.activeIcon,
    required this.inactiveIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: value
              ? Theme.of(context).colorScheme.secondary
              : Colors.grey.shade400,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: value ? 40 : 0,
              right: value ? 0 : 40,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  value ? activeIcon : inactiveIcon,
                  color: value
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}