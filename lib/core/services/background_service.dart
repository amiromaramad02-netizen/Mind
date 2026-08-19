import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'dailyReminder':
        debugPrint("Running daily reminder background task");
        // Trigger a notification for daily planning
        break;
      case 'sessionTimeout':
        debugPrint("Running session timeout background task");
        // Handle session that might have been lost while app was dead
        break;
    }
    return Future.value(true);
  });
}

class BackgroundService {
  static Future<void> init() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
  }

  static Future<void> scheduleDailyReminder() async {
    await Workmanager().registerPeriodicTask(
      "1",
      "dailyReminder",
      frequency: const Duration(hours: 24),
      initialDelay: const Duration(seconds: 10),
    );
  }
}
