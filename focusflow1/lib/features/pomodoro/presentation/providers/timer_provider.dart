import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/pomodoro_session.dart';
import '../../data/repositories/pomodoro_repository_impl.dart';
import '../../../../core/services/database_service.dart';

enum PomodoroState { focus, shortBreak, longBreak, idle }

class TimerStatus {
  const TimerStatus({
    required this.secondsRemaining,
    required this.isRunning,
    required this.currentState,
    required this.completedSessions,
    this.sessionStartTime,
    this.endsAt,
    this.selectedTaskId,
  });

  final int secondsRemaining;
  final bool isRunning;
  final PomodoroState currentState;
  final int completedSessions;
  final DateTime? sessionStartTime;
  final DateTime? endsAt;
  final String? selectedTaskId;

  TimerStatus copyWith({
    int? secondsRemaining,
    bool? isRunning,
    PomodoroState? currentState,
    int? completedSessions,
    DateTime? sessionStartTime,
    DateTime? endsAt,
    String? selectedTaskId,
  }) {
    return TimerStatus(
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isRunning: isRunning ?? this.isRunning,
      currentState: currentState ?? this.currentState,
      completedSessions: completedSessions ?? this.completedSessions,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      endsAt: endsAt ?? this.endsAt,
      selectedTaskId: selectedTaskId ?? this.selectedTaskId,
    );
  }

  double get progress {
    final total = switch (currentState) {
      PomodoroState.shortBreak => PomodoroTimer.shortBreakDuration,
      PomodoroState.longBreak => PomodoroTimer.longBreakDuration,
      _ => PomodoroTimer.focusDuration,
    };
    return 1 - (secondsRemaining / total).clamp(0, 1);
  }
}

final pomodoroTimerProvider =
    StateNotifierProvider<PomodoroTimer, TimerStatus>((ref) {
  return PomodoroTimer(ref);
});

class PomodoroTimer extends StateNotifier<TimerStatus> {
  PomodoroTimer(this._ref)
      : super(
          const TimerStatus(
            secondsRemaining: focusDuration,
            isRunning: false,
            currentState: PomodoroState.idle,
            completedSessions: 0,
          ),
        );

  Timer? _timer;
  final Ref _ref;
  static const int focusDuration = 25 * 60;
  static const int shortBreakDuration = 5 * 60;
  static const int longBreakDuration = 20 * 60;

  void startTimer({String? taskId}) {
    if (state.isRunning) return;
    
    final now = DateTime.now();
    final mode = state.currentState == PomodoroState.idle
        ? PomodoroState.focus
        : state.currentState;
    state = state.copyWith(
      isRunning: true,
      sessionStartTime: state.sessionStartTime ?? now,
      currentState: mode,
      endsAt: now.add(Duration(seconds: state.secondsRemaining)),
      selectedTaskId: taskId,
    );
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final endsAt = state.endsAt;
      final secondsLeft = endsAt == null
          ? state.secondsRemaining - 1
          : endsAt.difference(DateTime.now()).inSeconds;
      if (secondsLeft > 0) {
        state = state.copyWith(secondsRemaining: secondsLeft);
      } else {
        _handleSessionComplete();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false, endsAt: null);
  }

  void resetTimer() {
    _timer?.cancel();
    state = const TimerStatus(
      secondsRemaining: focusDuration,
      isRunning: false,
      currentState: PomodoroState.idle,
      completedSessions: 0,
    );
  }

  Future<void> _handleSessionComplete() async {
    _timer?.cancel();
    
    // Save completed session if it was a focus session
    if (state.currentState == PomodoroState.focus && state.sessionStartTime != null) {
      final session = PomodoroSession(
        startTime: state.sessionStartTime!,
        endTime: DateTime.now(),
        durationMinutes: (focusDuration / 60).round(),
        type: 'focus',
        taskId: state.selectedTaskId,
      );
      final repositoryState = _ref.read(databaseServiceProvider);
      if (repositoryState.hasValue) {
        await _ref.read(pomodoroRepositoryProvider).saveSession(session);
      }
    }

    PomodoroState nextState;
    int nextDuration;
    int nextSessions = state.completedSessions;

    if (state.currentState == PomodoroState.focus) {
      nextSessions++;
      if (nextSessions % 4 == 0) {
        nextState = PomodoroState.longBreak;
        nextDuration = longBreakDuration;
      } else {
        nextState = PomodoroState.shortBreak;
        nextDuration = shortBreakDuration;
      }
    } else {
      nextState = PomodoroState.focus;
      nextDuration = focusDuration;
    }

    state = state.copyWith(
      secondsRemaining: nextDuration,
      isRunning: false,
      currentState: nextState,
      completedSessions: nextSessions,
      sessionStartTime: null,
      endsAt: null,
    );
  }

  Future<void> skip() => _handleSessionComplete();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
