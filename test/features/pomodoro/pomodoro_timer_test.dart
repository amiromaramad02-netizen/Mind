import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindsync/features/pomodoro/presentation/providers/timer_provider.dart';

void main() {
  group('PomodoroTimer tests', () {
    test('initial state is idle and 25 minutes', () {
      final container = ProviderContainer();
      final timerStatus = container.read(pomodoroTimerProvider);
      
      expect(timerStatus.currentState, PomodoroState.idle);
      expect(timerStatus.secondsRemaining, 25 * 60);
      expect(timerStatus.isRunning, false);
    });

    test('startTimer changes isRunning to true', () {
      final container = ProviderContainer();
      container.read(pomodoroTimerProvider.notifier).startTimer();
      
      final timerStatus = container.read(pomodoroTimerProvider);
      expect(timerStatus.isRunning, true);
      expect(timerStatus.currentState, PomodoroState.focus);
    });

    test('pauseTimer changes isRunning to false', () {
      final container = ProviderContainer();
      container.read(pomodoroTimerProvider.notifier).startTimer();
      container.read(pomodoroTimerProvider.notifier).pauseTimer();
      
      final timerStatus = container.read(pomodoroTimerProvider);
      expect(timerStatus.isRunning, false);
    });

    test('resetTimer restores initial values', () {
      final container = ProviderContainer();
      container.read(pomodoroTimerProvider.notifier).startTimer();
      container.read(pomodoroTimerProvider.notifier).resetTimer();
      
      final timerStatus = container.read(pomodoroTimerProvider);
      expect(timerStatus.currentState, PomodoroState.idle);
      expect(timerStatus.secondsRemaining, 25 * 60);
      expect(timerStatus.isRunning, false);
    });
  });
}
