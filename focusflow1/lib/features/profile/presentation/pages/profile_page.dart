import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:focusflow1/features/auth/data/repositories/auth_repository.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepositoryProvider);
    final user = authRepo.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
              // Navigate to onboarding or login
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildProfileHeader(user),
            const SizedBox(height: 32),
            _buildLevelProgress(),
            const SizedBox(height: 32),
            _buildAchievementsGrid(),
            const SizedBox(height: 32),
            _buildStatGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.indigo.shade100,
          child: const Icon(Icons.person, size: 50, color: Colors.indigo),
        ).animate().scale(),
        const SizedBox(height: 16),
        Text(
          user?.displayName ?? 'Focus Explorer',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          user?.email ?? 'guest@focusflow.com',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildLevelProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Level 5', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('1,250 / 1,500 XP'),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 1250 / 1500,
            backgroundColor: Colors.indigo.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            minHeight: 10,
          ),
          const SizedBox(height: 8),
          const Text(
            '250 XP to reach Level 6',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildAchievementsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Achievements',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: const [
            _AchievementIcon(icon: Icons.bolt, label: 'Fast Starter', isUnlocked: true),
            _AchievementIcon(icon: Icons.timer, label: 'Deep Work', isUnlocked: true),
            _AchievementIcon(icon: Icons.calendar_today, label: '7 Day Streak', isUnlocked: true),
            _AchievementIcon(icon: Icons.emoji_events, label: 'Champion', isUnlocked: false),
          ],
        ),
      ],
    );
  }

  Widget _buildStatGrid() {
    return const Row(
      children: [
        Expanded(child: _StatBox(label: 'Total Hours', value: '142')),
        SizedBox(width: 16),
        Expanded(child: _StatBox(label: 'Sessions', value: '312')),
        SizedBox(width: 16),
        Expanded(child: _StatBox(label: 'Rank', value: '#12')),
      ],
    );
  }
}

class _AchievementIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isUnlocked;

  const _AchievementIcon({required this.icon, required this.label, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUnlocked ? Colors.amber.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: isUnlocked ? Border.all(color: Colors.amber.withValues(alpha: 0.5)) : null,
          ),
          child: Icon(
            icon,
            color: isUnlocked ? Colors.amber : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
