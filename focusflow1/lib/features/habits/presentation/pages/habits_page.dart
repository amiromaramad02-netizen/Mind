import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/models/habit.dart';
import '../providers/habits_provider.dart';

class HabitsPage extends ConsumerWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits'),
      ),
      body: habitsAsync.when(
        data: (habits) => habits.isEmpty
            ? _buildEmptyState(context)
            : _buildHabitList(habits, ref),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddHabitSheet(context, ref),
        label: const Text('Add Habit'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome_mosaic_outlined,
            size: 80,
            color: Colors.grey[300],
          ).animate().scale(),
          const SizedBox(height: 24),
          const Text(
            'Start a new habit',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Consistency is the key to success.',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitList(List<Habit> habits, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        return _HabitListItem(habit: habit);
      },
    );
  }

  void _showAddHabitSheet(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('New Habit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Habit Name'),
              autofocus: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  ref.read(habitsListProvider.notifier).addHabit(
                    nameController.text,
                    '🔥',
                    Colors.indigo.toARGB32(),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Habit'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _HabitListItem extends ConsumerWidget {
  final Habit habit;

  const _HabitListItem({required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(habit.colorValue);
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final isCompletedToday = habit.completionDates.any((d) => 
      d.year == today.year && d.month == today.month && d.day == today.day);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (habit.id != null) {
                ref.read(habitsListProvider.notifier).toggleHabit(habit.id!);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCompletedToday ? color : color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompletedToday ? Icons.check : Icons.local_fire_department,
                color: isCompletedToday ? Colors.white : color,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${habit.currentStreak} day streak',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Row(
            children: List.generate(5, (index) {
              final date = DateTime.now().subtract(Duration(days: 4 - index));
              final isDone = habit.completionDates.any((d) => 
                d.year == date.year && d.month == date.month && d.day == date.day);
              
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? color : color.withValues(alpha: 0.1),
                ),
              );
            }),
          ),
        ],
      ),
    ).animate().fadeIn().slideX();
  }
}
