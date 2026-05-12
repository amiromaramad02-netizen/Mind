import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../shared/widgets/glass_card.dart';

class AIAssistantPage extends ConsumerStatefulWidget {
  const AIAssistantPage({super.key});

  @override
  ConsumerState<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends ConsumerState<AIAssistantPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Focus Assistant'),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.indigo.shade900,
                  Colors.purple.shade900,
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildAIBubble(
                        "Hello! I'm your FocusFlow Assistant. How can I help you optimize your productivity today?",
                      ).animate().fadeIn().slideY(begin: 0.1),
                      const SizedBox(height: 16),
                      _buildSuggestedActions(),
                    ],
                  ),
                ),
                _buildInputArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIBubble(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GlassCard(
        opacity: 0.1,
        padding: const EdgeInsets.all(16),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSuggestedActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Suggested Actions",
          style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _ActionChip(
          label: "Break down 'Final Project'",
          onTap: () {},
        ),
        _ActionChip(
          label: "My productivity insights",
          onTap: () {},
        ),
        _ActionChip(
          label: "Schedule recommendations",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Ask anything...",
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton.filled(
            onPressed: () {},
            icon: const Icon(Icons.send),
            style: IconButton.styleFrom(backgroundColor: Colors.indigo),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, color: Colors.indigoAccent, size: 16),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
