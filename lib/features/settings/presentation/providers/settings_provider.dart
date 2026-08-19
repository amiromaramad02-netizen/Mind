import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeSettingsProvider =
    StateNotifierProvider<ThemeSettings, ThemeMode>((ref) => ThemeSettings());

class ThemeSettings extends StateNotifier<ThemeMode> {
  ThemeSettings() : super(ThemeMode.system) {
    _loadTheme();
  }

  static const _themeKey = 'theme_mode';

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_themeKey);
    if (themeName != null) {
      state = ThemeMode.values.firstWhere((e) => e.name == themeName);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }
}

final timerSettingsProvider =
    StateNotifierProvider<TimerSettings, Map<String, int>>(
  (ref) => TimerSettings(),
);

class TimerSettings extends StateNotifier<Map<String, int>> {
  TimerSettings()
      : super({
          'focus': 25,
          'shortBreak': 5,
          'longBreak': 20,
        });

  void updateDuration(String type, int minutes) {
    state = {...state, type: minutes};
  }
}
