import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AIRepository {
  Future<String> getTaskBreakdown(String taskTitle);
  Future<String> getProductivityInsights(List<dynamic> sessionHistory);
  Future<String> getSmartScheduleRecommendation();
}

class MockAIRepository implements AIRepository {
  @override
  Future<String> getTaskBreakdown(String taskTitle) async {
    await Future.delayed(const Duration(seconds: 1));
    return "1. Research\n2. Outline\n3. First Draft\n4. Review";
  }

  @override
  Future<String> getProductivityInsights(List<dynamic> sessionHistory) async {
    return "You are most productive between 9 AM and 11 AM. Try scheduling your hardest tasks then.";
  }

  @override
  Future<String> getSmartScheduleRecommendation() async {
    return "Based on your habits, we recommend a 50-minute focus session followed by a 10-minute break today.";
  }
}

final aiRepositoryProvider = Provider<AIRepository>((ref) {
  return MockAIRepository();
});
