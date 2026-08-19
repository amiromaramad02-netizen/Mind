import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/pomodoro_session.dart';
import '../../../../core/services/database_service.dart';

class PomodoroRepository {
  PomodoroRepository(this._database);

  final DatabaseService _database;

  Future<void> saveSession(PomodoroSession session) async {
    final id = session.id ?? DateTime.now().microsecondsSinceEpoch;
    await _database.sessions.put(id, session.copyWith(id: id).toJson());
  }

  Future<List<PomodoroSession>> getSessionsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _readSessions()
        .where((session) =>
            session.startTime.isAfter(startOfDay) &&
            session.startTime.isBefore(endOfDay))
        .toList();
  }

  Stream<List<PomodoroSession>> watchTodaySessions() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final controller = StreamController<List<PomodoroSession>>();
    void emit() {
      controller.add(
        _readSessions()
            .where((session) => session.startTime.isAfter(startOfDay))
            .toList(),
      );
    }

    emit();
    final subscription = _database.sessions.watch().listen((_) => emit());
    controller.onCancel = subscription.cancel;
    return controller.stream;
  }

  List<PomodoroSession> _readSessions() {
    return _database.sessions.values
        .map((value) => PomodoroSession.fromJson(value))
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }
}

final pomodoroRepositoryProvider = Provider<PomodoroRepository>((ref) {
  final database = ref.watch(databaseServiceProvider).requireValue;
  return PomodoroRepository(database);
});
