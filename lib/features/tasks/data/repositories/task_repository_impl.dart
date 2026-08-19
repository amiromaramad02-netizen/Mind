import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/task.dart';
import '../../../../core/services/database_service.dart';

class TaskRepository {
  TaskRepository(this._database);

  final DatabaseService _database;

  Future<List<Task>> getAllTasks() async {
    return _readTasks();
  }

  Future<void> saveTask(Task task) async {
    final id = task.id ?? DateTime.now().microsecondsSinceEpoch;
    await _database.tasks.put(id, task.copyWith(id: id).toJson());
  }

  Future<void> deleteTask(int id) async {
    await _database.tasks.delete(id);
  }

  Stream<List<Task>> watchTasks() {
    final controller = StreamController<List<Task>>();
    controller.add(_readTasks());
    final subscription = _database.tasks.watch().listen((_) {
      controller.add(_readTasks());
    });
    controller.onCancel = subscription.cancel;
    return controller.stream;
  }

  List<Task> _readTasks() {
    final tasks = _database.tasks.values
        .map((value) => Task.fromJson(value))
        .toList()
      ..sort((a, b) => (b.createdAt ?? DateTime(0))
          .compareTo(a.createdAt ?? DateTime(0)));
    return tasks;
  }
}

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final database = ref.watch(databaseServiceProvider).requireValue;
  return TaskRepository(database);
});
