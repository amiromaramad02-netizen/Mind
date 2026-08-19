import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hapticServiceProvider =
    Provider<HapticService>((ref) => const HapticService());

class HapticService {
  const HapticService();

  Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  Future<void> success() async {
    // Success haptic feedback (iOS/Android compatible)
    await HapticFeedback.vibrate();
  }
}
