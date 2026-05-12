import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BreathingAnimation extends StatelessWidget {
  final bool isRunning;
  final Color color;

  const BreathingAnimation({
    super.key,
    required this.isRunning,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (!isRunning) return const SizedBox.shrink();

    return Stack(
      alignment: Alignment.center,
      children: [
        _buildCircle(1.0, 0.1),
        _buildCircle(1.2, 0.08),
        _buildCircle(1.4, 0.05),
      ],
    );
  }

  Widget _buildCircle(double scale, double opacity) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    )
    .animate(onPlay: (controller) => controller.repeat(reverse: true))
    .scale(
      begin: const Offset(0.8, 0.8),
      end: Offset(scale, scale),
      duration: 4.seconds,
      curve: Curves.easeInOutSine,
    )
    .fadeIn(duration: 2.seconds);
  }
}
