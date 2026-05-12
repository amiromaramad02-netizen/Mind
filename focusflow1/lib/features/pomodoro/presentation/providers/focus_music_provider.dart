import 'package:flutter_riverpod/flutter_riverpod.dart';

class FocusSound {
  final String id;
  final String name;
  final String assetPath;
  final String icon;

  FocusSound({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.icon,
  });
}

final focusMusicProvider =
    StateNotifierProvider<FocusMusic, FocusSound?>((ref) => FocusMusic());

class FocusMusic extends StateNotifier<FocusSound?> {
  FocusMusic() : super(null);

  List<FocusSound> get availableSounds => [
    FocusSound(id: 'rain', name: 'Soft Rain', assetPath: 'audio/rain.mp3', icon: 'rain'),
    FocusSound(id: 'forest', name: 'Forest Birds', assetPath: 'audio/forest.mp3', icon: 'forest'),
    FocusSound(id: 'white_noise', name: 'White Noise', assetPath: 'audio/white_noise.mp3', icon: 'noise'),
    FocusSound(id: 'waves', name: 'Ocean Waves', assetPath: 'audio/waves.mp3', icon: 'waves'),
    FocusSound(id: 'lofi', name: 'Lofi Beats', assetPath: 'audio/lofi.mp3', icon: 'music'),
  ];

  void selectSound(FocusSound sound) {
    if (state?.id == sound.id) {
      state = null; // Toggle off
    } else {
      state = sound;
    }
  }
}
