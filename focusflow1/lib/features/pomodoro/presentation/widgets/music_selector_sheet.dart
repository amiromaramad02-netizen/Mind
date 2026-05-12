import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/focus_music_provider.dart';

class MusicSelectorSheet extends ConsumerWidget {
  const MusicSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSound = ref.watch(focusMusicProvider);
    final musicNotifier = ref.read(focusMusicProvider.notifier);
    final sounds = musicNotifier.availableSounds;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1B4B), // Match Pomodoro page bg
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Focus Ambiance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            itemCount: sounds.length,
            itemBuilder: (context, index) {
              final sound = sounds[index];
              final isSelected = selectedSound?.id == sound.id;

              return ListTile(
                onTap: () => musicNotifier.selectSound(sound),
                leading: Text(sound.icon, style: const TextStyle(fontSize: 24)),
                title: Text(
                  sound.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected 
                  ? const Icon(Icons.check_circle, color: Colors.white)
                  : null,
                contentPadding: EdgeInsets.zero,
              );
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.white54)),
            ),
          ),
        ],
      ),
    );
  }
}
