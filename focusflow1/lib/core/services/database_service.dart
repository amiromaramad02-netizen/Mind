import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final databaseServiceProvider = FutureProvider<DatabaseService>((ref) async {
  final service = DatabaseService();
  await service.init();
  return service;
});

class DatabaseService {
  static const tasksBox = 'mindsync_tasks';
  static const sessionsBox = 'mindsync_sessions';
  static const habitsBox = 'mindsync_habits';
  static const settingsBox = 'mindsync_settings';

  Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<Map>(tasksBox),
      Hive.openBox<Map>(sessionsBox),
      Hive.openBox<Map>(habitsBox),
      Hive.openBox(settingsBox),
    ]);
  }

  Box<Map> get tasks => Hive.box<Map>(tasksBox);
  Box<Map> get sessions => Hive.box<Map>(sessionsBox);
  Box<Map> get habits => Hive.box<Map>(habitsBox);
  Box get settings => Hive.box(settingsBox);
}
