import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:focusflow1/features/pomodoro/presentation/providers/timer_provider.dart';
import 'package:focusflow1/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:focusflow1/core/services/quotes_service.dart';
import 'package:focusflow1/shared/widgets/glass_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(pomodoroTimerProvider);
    final tasksAsync = ref.watch(tasksListProvider);
    final quote = QuotesService.getRandomQuote();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('FocusFlow'),
            actions: [
              IconButton(
                icon: const Icon(Icons.bar_chart_outlined),
                onPressed: () => context.push('/analytics'),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.push('/settings'),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreeting(quote),
                  const SizedBox(height: 24),
                  _buildQuickTimerCard(context, timerState),
                  const SizedBox(height: 32),
                  _buildSectionHeader(
                    'Today\'s Tasks',
                    () => context.push('/tasks'),
                  ),
                  const SizedBox(height: 12),
                  tasksAsync.when(
                    data: (tasks) => _buildTaskList(ref, tasks.take(3).toList()),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Error: $e'),
                  ),
                  const SizedBox(height: 32),
                  _buildHabitPreview(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/pomodoro'),
        label: Text(timerState.isRunning ? 'Continue Focus' : 'Start Focus'),
        icon: Icon(timerState.isRunning ? Icons.pause : Icons.play_arrow),
      ),
    );
  }

  Widget _buildGreeting(Quote quote) {
    final hour = DateTime.now().hour;
    String greeting = 'Good Morning';
    if (hour >= 12 && hour < 17) greeting = 'Good Afternoon';
    if (hour >= 17) greeting = 'Good Evening';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, FocusFlow User',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          '"${quote.text}"',
          style: const TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '- ${quote.author}',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
      ],
    ).animate().fadeIn().slideX();
  }

  Widget _buildQuickTimerCard(BuildContext context, TimerStatus timerState) {
    return GlassCard(
      opacity: 0.05,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Goal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Finish 4 Pomodoros today',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Text(
                '${timerState.completedSessions}/4',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (timerState.completedSessions % 5) / 4,
              minHeight: 8,
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    ).animate().scale();
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Row(
            children: [
              Text('See all'),
              Icon(Icons.chevron_right, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList(WidgetRef ref, List<dynamic> tasks) {
    if (tasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          children: [
            Icon(Icons.task_alt, color: Colors.grey),
            SizedBox(height: 8),
            Text('No tasks for today', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      children: tasks.map((task) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: ListTile(
          onTap: () => ref.read(tasksListProvider.notifier).toggleTaskCompletion(task),
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (v) => ref.read(tasksListProvider.notifier).toggleTaskCompletion(task),
            shape: const CircleBorder(),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? Colors.grey : null,
            ),
          ),
          trailing: const Icon(Icons.more_vert, size: 18),
        ),
      )).toList(),
    ).animate().fadeIn();
  }

  Widget _buildHabitPreview() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Habit Streaks',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _HabitCard(name: 'Reading', streak: 5, color: Colors.orange),
              _HabitCard(name: 'Meditation', streak: 12, color: Colors.blue),
              _HabitCard(name: 'Workout', streak: 3, color: Colors.green),
            ],
          ),
        ),
      ],
    );
  }
}

class _HabitCard extends StatelessWidget {
  final String name;
  final int streak;
  final Color color;

  const _HabitCard({required this.name, required this.streak, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.local_fire_department, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            '$streak days',
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
