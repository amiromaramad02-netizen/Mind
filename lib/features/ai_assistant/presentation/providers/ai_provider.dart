import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/ai_repository.dart';

final aiConversationProvider =
    StateNotifierProvider<AIConversation, List<Map<String, String>>>((ref) {
  return AIConversation(ref.watch(aiRepositoryProvider));
});

class AIConversation extends StateNotifier<List<Map<String, String>>> {
  AIConversation(this._repository)
      : super([
          {
            'role': 'assistant',
            'content':
                "Hello! I'm your MindSync Assistant. How can I help you optimize your productivity today?",
          }
        ]);

  final AIRepository _repository;

  Future<void> sendMessage(String message) async {
    state = [...state, {'role': 'user', 'content': message}];
    
    // Simulate AI thinking
    String response;
    
    if (message.toLowerCase().contains('break down')) {
      response = await _repository.getTaskBreakdown(message);
    } else if (message.toLowerCase().contains('insight')) {
      response = await _repository.getProductivityInsights([]);
    } else {
      response = "I'm still learning, but I can help you break down tasks or give you productivity insights!";
    }
    
    state = [...state, {'role': 'assistant', 'content': response}];
  }
}
