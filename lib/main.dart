import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindsync/routes/app_router.dart';
import 'package:mindsync/theme/app_theme.dart';
import 'package:mindsync/core/services/database_service.dart';
import 'package:mindsync/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // We use a ProviderContainer to initialize services before the app runs
  final container = ProviderContainer();

  try {
    // Initialize Isar
    await container.read(databaseServiceProvider.future);
    // Initialize Notifications
    await container.read(notificationServiceProvider.future);
  } catch (e) {
    debugPrint('Error during initialization: $e');
  }

  runApp(
    UncontrolledProviderScope(container: container, child: const MindSyncApp()),
  );
}

class MindSyncApp extends ConsumerWidget {
  const MindSyncApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'MindSync',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
