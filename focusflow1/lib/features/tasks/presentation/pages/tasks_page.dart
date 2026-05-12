import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/models/task.dart';
import '../providers/tasks_provider.dart';
import '../widgets/add_task_sheet.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // TODO: Implement sorting
            },
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) => tasks.isEmpty
            ? _buildEmptyState(context)
            : _buildTaskList(context, ref, tasks),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskSheet(context),
        label: const Text('New Task'),
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
            Icons.assignment_turned_in_outlined,
            size: 100,
            color: Colors.grey[300],
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          const Text(
            'All caught up!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a task to start your focus session.',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, WidgetRef ref, List<Task> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Dismissible(
          key: Key(task.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            if (task.id != null) {
              ref.read(tasksListProvider.notifier).deleteTask(task.id!);
            }
          },
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: _PriorityIndicator(priority: task.priority),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  fontWeight: FontWeight.w600,
                  color: task.isCompleted ? Colors.grey : null,
                ),
              ),
              subtitle: Text(
                '${task.completedPomodoros}/${task.estimatedPomodoros} Pomodoros',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              trailing: Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    ref.read(tasksListProvider.notifier).toggleTaskCompletion(task);
                  },
                  shape: const CircleBorder(),
                ),
              ),
            ),
          ).animate().fadeIn(delay: (index * 50).ms).slideX(),
        );
      },
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTaskSheet(),
    );
  }
}

class _PriorityIndicator extends StatelessWidget {
  final TaskPriority priority;

  const _PriorityIndicator({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (priority) {
      case TaskPriority.high:
        color = const Color(0xFFEF4444);
        break;
      case TaskPriority.medium:
        color = const Color(0xFFF59E0B);
        break;
      case TaskPriority.low:
        color = const Color(0xFF10B981);
        break;
    }
    return Container(
      width: 4,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
