enum TaskPriority { low, medium, high }

enum TaskStatus { pending, inProgress, completed }

class Task {
  const Task({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.dueDate,
    this.estimatedPomodoros = 1,
    this.completedPomodoros = 0,
    this.tags = const [],
    this.category = 'Today',
    this.subtasks = const [],
    this.createdAt,
  });

  final int? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime? dueDate;
  final int estimatedPomodoros;
  final int completedPomodoros;
  final List<String> tags;
  final String category;
  final List<String> subtasks;
  final DateTime? createdAt;

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? dueDate,
    int? estimatedPomodoros,
    int? completedPomodoros,
    List<String>? tags,
    String? category,
    List<String>? subtasks,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      estimatedPomodoros: estimatedPomodoros ?? this.estimatedPomodoros,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      subtasks: subtasks ?? this.subtasks,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
        'priority': priority.name,
        'status': status.name,
        'dueDate': dueDate?.toIso8601String(),
        'estimatedPomodoros': estimatedPomodoros,
        'completedPomodoros': completedPomodoros,
        'tags': tags,
        'category': category,
        'subtasks': subtasks,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory Task.fromJson(Map<dynamic, dynamic> json) {
    final completed = json['isCompleted'] as bool? ?? false;
    return Task(
      id: json['id'] as int?,
      title: json['title'] as String? ?? 'Untitled task',
      description: json['description'] as String?,
      isCompleted: completed,
      priority: TaskPriority.values.firstWhere(
        (value) => value.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      status: TaskStatus.values.firstWhere(
        (value) => value.name == json['status'],
        orElse: () => completed ? TaskStatus.completed : TaskStatus.pending,
      ),
      dueDate: _date(json['dueDate']),
      estimatedPomodoros: json['estimatedPomodoros'] as int? ?? 1,
      completedPomodoros: json['completedPomodoros'] as int? ?? 0,
      tags: List<String>.from(json['tags'] as List? ?? const []),
      category: json['category'] as String? ?? 'Today',
      subtasks: List<String>.from(json['subtasks'] as List? ?? const []),
      createdAt: _date(json['createdAt']) ?? DateTime.now(),
    );
  }

  static DateTime? _date(dynamic value) =>
      value is String ? DateTime.tryParse(value) : null;
}
