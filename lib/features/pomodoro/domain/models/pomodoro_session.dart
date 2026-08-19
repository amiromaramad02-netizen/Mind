class PomodoroSession {
  const PomodoroSession({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.type,
    this.taskId,
    this.note,
    this.moodRating,
  });

  final int? id;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final String type;
  final String? taskId;
  final String? note;
  final int? moodRating;

  PomodoroSession copyWith({
    int? id,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    String? type,
    String? taskId,
    String? note,
    int? moodRating,
  }) {
    return PomodoroSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      type: type ?? this.type,
      taskId: taskId ?? this.taskId,
      note: note ?? this.note,
      moodRating: moodRating ?? this.moodRating,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'durationMinutes': durationMinutes,
        'type': type,
        'taskId': taskId,
        'note': note,
        'moodRating': moodRating,
      };

  factory PomodoroSession.fromJson(Map<dynamic, dynamic> json) {
    return PomodoroSession(
      id: json['id'] as int?,
      startTime: DateTime.tryParse(json['startTime'] as String? ?? '') ??
          DateTime.now(),
      endTime:
          DateTime.tryParse(json['endTime'] as String? ?? '') ?? DateTime.now(),
      durationMinutes: json['durationMinutes'] as int? ?? 25,
      type: json['type'] as String? ?? 'focus',
      taskId: json['taskId'] as String?,
      note: json['note'] as String?,
      moodRating: json['moodRating'] as int?,
    );
  }
}
