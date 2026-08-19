import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/home/presentation/pages/home_dashboard_page.dart';
import '../features/pomodoro/presentation/pages/pomodoro_page.dart';
import '../features/tasks/presentation/pages/task_manager_page.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeDashboardPage(),
    ),
    GoRoute(
      path: '/pomodoro',
      builder: (context, state) => const PomodoroPage(),
    ),
    GoRoute(
      path: '/tasks',
      builder: (context, state) => const TaskManagerPage(),
    ),
  ],
);