class FocusJournalEntry {
  const FocusJournalEntry({
    this.id,
    required this.timestamp,
    required this.content,
    this.moodRating = 3,
    this.sessionId,
    this.tags = const [],
  });

  final int? id;
  final DateTime timestamp;
  final String content;
  final int moodRating;
  final String? sessionId;
  final List<String> tags;

  FocusJournalEntry copyWith({
    int? id,
    DateTime? timestamp,
    String? content,
    int? moodRating,
    String? sessionId,
    List<String>? tags,
  }) {
    return FocusJournalEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      content: content ?? this.content,
      moodRating: moodRating ?? this.moodRating,
      sessionId: sessionId ?? this.sessionId,
      tags: tags ?? this.tags,
    );
  }
}
