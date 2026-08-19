class Habit {
  const Habit({
    this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
    this.currentStreak = 0,
    this.completionDates = const [],
    required this.createdAt,
    this.isActive = true,
    this.goalPerWeek = 7,
  });

  final int? id;
  final String name;
  final String icon;
  final int colorValue;
  final int currentStreak;
  final List<DateTime> completionDates;
  final DateTime createdAt;
  final bool isActive;
  final int goalPerWeek;

  Habit copyWith({
    int? id,
    String? name,
    String? icon,
    int? colorValue,
    int? currentStreak,
    List<DateTime>? completionDates,
    DateTime? createdAt,
    bool? isActive,
    int? goalPerWeek,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorValue: colorValue ?? this.colorValue,
      currentStreak: currentStreak ?? this.currentStreak,
      completionDates: completionDates ?? this.completionDates,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      goalPerWeek: goalPerWeek ?? this.goalPerWeek,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'colorValue': colorValue,
        'currentStreak': currentStreak,
        'completionDates':
            completionDates.map((date) => date.toIso8601String()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'isActive': isActive,
        'goalPerWeek': goalPerWeek,
      };

  factory Habit.fromJson(Map<dynamic, dynamic> json) {
    return Habit(
      id: json['id'] as int?,
      name: json['name'] as String? ?? 'Habit',
      icon: json['icon'] as String? ?? 'bolt',
      colorValue: json['colorValue'] as int? ?? 0xFF6366F1,
      currentStreak: json['currentStreak'] as int? ?? 0,
      completionDates: (json['completionDates'] as List? ?? const [])
          .whereType<String>()
          .map(DateTime.parse)
          .toList(),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      isActive: json['isActive'] as bool? ?? true,
      goalPerWeek: json['goalPerWeek'] as int? ?? 7,
    );
  }
}
