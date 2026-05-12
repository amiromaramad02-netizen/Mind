import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/habit.dart';
import '../../data/repositories/habit_repository_impl.dart';

final habitsListProvider =
    StateNotifierProvider<HabitsList, AsyncValue<List<Habit>>>((ref) {
  return HabitsList(ref.watch(habitRepositoryProvider));
});

class HabitsList extends StateNotifier<AsyncValue<List<Habit>>> {
  HabitsList(this._repository) : super(const AsyncValue.loading()) {
    _subscription = _repository.watchHabits().listen(
          (habits) => state = AsyncValue.data(habits),
          onError: (Object error, StackTrace stackTrace) =>
              state = AsyncValue.error(error, stackTrace),
        );
  }

  final HabitRepository _repository;
  late final StreamSubscription<List<Habit>> _subscription;

  Future<void> addHabit(String name, String icon, int colorValue) async {
    final newHabit = Habit(
      name: name,
      icon: icon,
      colorValue: colorValue,
      createdAt: DateTime.now(),
    );
    await _repository.saveHabit(newHabit);
  }

  Future<void> toggleHabit(int id) async {
    await _repository.toggleHabitCompletion(id, DateTime.now());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
