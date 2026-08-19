import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/achievement.dart';

final userStatsProvider = StateNotifierProvider<UserStats, UserProgress>((ref) {
  return UserStats();
});

class UserStats extends StateNotifier<UserProgress> {
  UserStats()
      : super(
          const UserProgress(
            currentXp: 1250,
            currentLevel: 5,
            totalFocusMinutes: 1420,
            totalSessionsCompleted: 56,
            longestStreak: 12,
          ),
        );

  void addXp(int amount) {
    int newXp = state.currentXp + amount;
    int newLevel = state.currentLevel;
    
    // Simple level up logic: each level is 500 XP
    if (newXp >= newLevel * 500) {
      newLevel++;
    }
    
    state = state.copyWith(
      currentXp: newXp,
      currentLevel: newLevel,
    );
  }

  void recordSession(int minutes) {
    state = state.copyWith(
      totalFocusMinutes: state.totalFocusMinutes + minutes,
      totalSessionsCompleted: state.totalSessionsCompleted + 1,
    );
    addXp(minutes * 2); // 2 XP per minute focused
  }
}
