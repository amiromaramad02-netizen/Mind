class Achievement {
  const Achievement({
    this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.xpReward = 0,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  final int? id;
  final String title;
  final String description;
  final String icon;
  final int xpReward;
  final bool isUnlocked;
  final DateTime? unlockedAt;
}

class UserProgress {
  const UserProgress({
    this.id,
    this.currentXp = 0,
    this.currentLevel = 1,
    this.totalFocusMinutes = 0,
    this.totalSessionsCompleted = 0,
    this.longestStreak = 0,
  });

  final int? id;
  final int currentXp;
  final int currentLevel;
  final int totalFocusMinutes;
  final int totalSessionsCompleted;
  final int longestStreak;

  UserProgress copyWith({
    int? id,
    int? currentXp,
    int? currentLevel,
    int? totalFocusMinutes,
    int? totalSessionsCompleted,
    int? longestStreak,
  }) {
    return UserProgress(
      id: id ?? this.id,
      currentXp: currentXp ?? this.currentXp,
      currentLevel: currentLevel ?? this.currentLevel,
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      totalSessionsCompleted:
          totalSessionsCompleted ?? this.totalSessionsCompleted,
      longestStreak: longestStreak ?? this.longestStreak,
    );
  }
}
