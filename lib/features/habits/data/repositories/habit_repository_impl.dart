import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/habit.dart';
import '../../../../core/services/database_service.dart';

class HabitRepository {
  HabitRepository(this._database);

  final DatabaseService _database;

  Future<List<Habit>> getAllHabits() async {
    return _readHabits();
  }

  Future<void> saveHabit(Habit habit) async {
    final id = habit.id ?? DateTime.now().microsecondsSinceEpoch;
    await _database.habits.put(id, habit.copyWith(id: id).toJson());
  }

  Future<void> toggleHabitCompletion(int id, DateTime date) async {
    final raw = _database.habits.get(id);
    if (raw == null) return;
    final habit = Habit.fromJson(raw);
    final dates = List<DateTime>.from(habit.completionDates);
    final dateOnly = DateTime(date.year, date.month, date.day);

    final existingIndex = dates.indexWhere((saved) =>
        saved.year == dateOnly.year &&
        saved.month == dateOnly.month &&
        saved.day == dateOnly.day);
    if (existingIndex >= 0) {
      dates.removeAt(existingIndex);
    } else {
      dates.add(dateOnly);
    }

    int streak = 0;
    var checkDate = DateTime.now();
    var cursor = DateTime(checkDate.year, checkDate.month, checkDate.day);
    while (dates.any((saved) =>
        saved.year == cursor.year &&
        saved.month == cursor.month &&
        saved.day == cursor.day)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    await saveHabit(habit.copyWith(
      completionDates: dates,
      currentStreak: streak,
    ));
  }

  Stream<List<Habit>> watchHabits() {
    final controller = StreamController<List<Habit>>();
    controller.add(_readHabits());
    final subscription = _database.habits.watch().listen((_) {
      controller.add(_readHabits());
    });
    controller.onCancel = subscription.cancel;
    return controller.stream;
  }

  List<Habit> _readHabits() {
    return _database.habits.values.map((value) => Habit.fromJson(value)).toList()
      ..sort((a, b) => b.currentStreak.compareTo(a.currentStreak));
  }
}

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final database = ref.watch(databaseServiceProvider).requireValue;
  return HabitRepository(database);
});
