import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timer_provider.dart';
import '../widgets/breathing_animation.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FocusModePage extends ConsumerWidget {
  const FocusModePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(pomodoroTimerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: BreathingAnimation(
              isRunning: timerState.isRunning,
              color: Colors.white24,
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  _getTimerText(timerState.secondsRemaining),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 120,
                    fontWeight: FontWeight.w100,
                    letterSpacing: -5,
                  ),
                ).animate().fadeIn(duration: 2.seconds),
                const SizedBox(height: 20),
                Text(
                  _getMessage(timerState.currentState),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 16,
                    letterSpacing: 4,
                  ),
                ).animate().fadeIn(delay: 1.seconds),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white30),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTimerText(int seconds) {
    final m = (seconds / 60).floor();
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _getMessage(PomodoroState state) {
    switch (state) {
      case PomodoroState.focus:
        return 'STAY FOCUSED';
      case PomodoroState.shortBreak:
        return 'TAKE A BREATH';
      case PomodoroState.longBreak:
        return 'RECHARGE';
      case PomodoroState.idle:
        return 'READY';
    }
  }
}
