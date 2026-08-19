import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindsync/features/pomodoro/presentation/providers/timer_provider.dart';
import 'package:mindsync/features/pomodoro/presentation/widgets/breathing_animation.dart';
import 'package:mindsync/core/services/audio_service.dart';
import 'package:mindsync/core/services/notification_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PomodoroPage extends ConsumerWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(pomodoroTimerProvider);
    final timerNotifier = ref.read(pomodoroTimerProvider.notifier);

    // Listen for session completion to trigger sounds/notifications
    ref.listen(pomodoroTimerProvider, (previous, next) {
      if (previous?.isRunning == true && !next.isRunning && next.secondsRemaining > 0) {
        // This is a simplified check for session completion in this mock-up
        // In a real app, we'd have a specific "onComplete" event
        if (next.secondsRemaining == PomodoroTimer.focusDuration ||
            next.secondsRemaining == PomodoroTimer.shortBreakDuration) {
           ref.read(audioServiceProvider.notifier).playSessionComplete();
           ref.read(notificationServiceProvider.future).then(
                 (service) => service.showNotification(
                   id: 1,
                   title: 'Session Complete!',
                   body: next.currentState == PomodoroState.focus
                       ? 'Time for a break!'
                       : 'Back to work!',
                 ),
               );
        }
      }
    });

    final bgColor = _getBackgroundColor(timerState.currentState);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          AnimatedContainer(
            duration: 1.seconds,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  bgColor,
                  Color.lerp(bgColor, Colors.white, 0.08)!,
                ],
              ),
            ),
          ),

          // Breathing Animation Layer
          Center(
            child: BreathingAnimation(
              isRunning: timerState.isRunning,
              color: Colors.white,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                const Spacer(),
                _buildSessionType(timerState.currentState),
                const SizedBox(height: 48),
                _buildTimerDisplay(timerState),
                const Spacer(),
                _buildControls(timerState, timerNotifier, ref),
                const SizedBox(height: 48),
                _buildProgressDots(timerState),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.expand_more, color: Colors.white, size: 32),
            onPressed: () => Navigator.of(context).pop(),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(PomodoroState state) {
    switch (state) {
      case PomodoroState.focus:
        return const Color(0xFF1E1B4B); // Deep Indigo
      case PomodoroState.shortBreak:
        return const Color(0xFF064E3B); // Deep Emerald
      case PomodoroState.longBreak:
        return const Color(0xFF1E3A8A); // Deep Blue
      case PomodoroState.idle:
        return const Color(0xFF0F172A); // Slate 900
    }
  }

  Widget _buildSessionType(PomodoroState state) {
    String label;
    switch (state) {
      case PomodoroState.focus: label = 'FOCUS'; break;
      case PomodoroState.shortBreak: label = 'SHORT BREAK'; break;
      case PomodoroState.longBreak: label = 'LONG BREAK'; break;
      case PomodoroState.idle: label = 'GET READY'; break;
    }
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w800,
        letterSpacing: 8,
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildTimerDisplay(TimerStatus state) {
    final minutes = (state.secondsRemaining / 60).floor();
    final seconds = state.secondsRemaining % 60;

    return Column(
      children: [
        Text(
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 100,
            fontWeight: FontWeight.w200,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ).animate(target: state.isRunning ? 1 : 0)
         .shimmer(duration: 3.seconds, color: Colors.white24),
        if (state.currentState == PomodoroState.focus)
           const Text(
            'Keep it up!',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ).animate().fadeIn(),
      ],
    );
  }

  Widget _buildControls(TimerStatus state, PomodoroTimer notifier, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CircleButton(
          icon: Icons.refresh,
          onPressed: () {
            ref.read(audioServiceProvider.notifier).playClick();
            notifier.resetTimer();
          },
          size: 56,
          isSecondary: true,
        ),
        const SizedBox(width: 32),
        _CircleButton(
          icon: state.isRunning ? Icons.pause : Icons.play_arrow,
          onPressed: () {
            ref.read(audioServiceProvider.notifier).playClick();
            state.isRunning ? notifier.pauseTimer() : notifier.startTimer();
          },
          size: 88,
        ),
        const SizedBox(width: 32),
        _CircleButton(
          icon: Icons.skip_next,
          onPressed: () {
            ref.read(audioServiceProvider.notifier).playClick();
            notifier.skip();
          },
          size: 56,
          isSecondary: true,
        ),
      ],
    );
  }

  Widget _buildProgressDots(TimerStatus state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isActive = index < (state.completedSessions % 4);
        return AnimatedContainer(
          duration: 300.ms,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 12 : 8,
          height: isActive ? 12 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.white : Colors.white24,
            boxShadow: isActive ? [
              BoxShadow(color: Colors.white.withValues(alpha: 0.5), blurRadius: 10)
            ] : null,
          ),
        );
      }),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final bool isSecondary;

  const _CircleButton({
    required this.icon,
    required this.onPressed,
    required this.size,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSecondary ? Colors.white.withValues(alpha: 0.1) : Colors.white,
          border: isSecondary ? Border.all(color: Colors.white24) : null,
        ),
        child: Icon(
          icon,
          color: isSecondary ? Colors.white : Colors.black,
          size: size * 0.45,
        ),
      ),
    ).animate()
     .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), curve: Curves.easeOutBack);
  }
}
