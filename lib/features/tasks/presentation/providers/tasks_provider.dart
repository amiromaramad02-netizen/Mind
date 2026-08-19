import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/task.dart';
import '../../data/repositories/task_repository_impl.dart';

final tasksListProvider =
    StateNotifierProvider<TasksList, AsyncValue<List<Task>>>((ref) {
  return TasksList(ref.watch(taskRepositoryProvider));
});

class TasksList extends StateNotifier<AsyncValue<List<Task>>> {
  TasksList(this._repository) : super(const AsyncValue.loading()) {
    _subscription = _repository.watchTasks().listen(
          (tasks) => state = AsyncValue.data(tasks),
          onError: (Object error, StackTrace stackTrace) =>
              state = AsyncValue.error(error, stackTrace),
        );
  }

  final TaskRepository _repository;
  late final StreamSubscription<List<Task>> _subscription;

  Future<void> addTask(String title) async {
    final newTask = Task(
      title: title,
      createdAt: DateTime.now(),
      estimatedPomodoros: 1,
    );
    await _repository.saveTask(newTask);
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final completed = !task.isCompleted;
    await _repository.saveTask(
      task.copyWith(
        isCompleted: completed,
        status: completed ? TaskStatus.completed : TaskStatus.pending,
      ),
    );
  }

  Future<void> deleteTask(int id) async {
    await _repository.deleteTask(id);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
