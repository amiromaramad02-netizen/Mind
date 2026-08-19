import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/home/presentation/pages/main_wrapper.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/pomodoro/presentation/pages/pomodoro_page.dart';
import '../features/pomodoro/presentation/pages/focus_mode_page.dart';
import '../features/analytics/presentation/pages/analytics_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/tasks/presentation/pages/tasks_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/ai_assistant/presentation/pages/ai_assistant_page.dart';
import '../features/auth/presentation/pages/login_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainWrapper(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/tasks',
            builder: (context, state) => const TasksPage(),
          ),
          GoRoute(
            path: '/analytics',
            builder: (context, state) => const AnalyticsPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: '/pomodoro',
        builder: (context, state) => const PomodoroPage(),
      ),
      GoRoute(
        path: '/focus-mode',
        builder: (context, state) => const FocusModePage(),
      ),
      GoRoute(
        path: '/ai-assistant',
        builder: (context, state) => const AIAssistantPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
});
