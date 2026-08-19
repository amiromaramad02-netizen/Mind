import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioServiceProvider =
    StateNotifierProvider<AudioService, void>((ref) => AudioService());

class AudioService extends StateNotifier<void> {
  AudioService() : super(null);

  final AudioPlayer _player = AudioPlayer();

  Future<void> playSessionComplete() async {
    try {
      await _player.play(AssetSource('audio/complete.mp3'));
    } catch (_) {
      // Audio assets are optional during early builds.
    }
  }

  Future<void> playClick() async {
    try {
      await _player.play(AssetSource('audio/click.mp3'), volume: 0.5);
    } catch (_) {}
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
