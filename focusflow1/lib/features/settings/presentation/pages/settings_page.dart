import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeSettingsProvider);
    final timerSettings = ref.watch(timerSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Appearance'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme Mode'),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              underline: const SizedBox(),
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeSettingsProvider.notifier).setThemeMode(mode);
                }
              },
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
            ),
          ),
          const Divider(),
          _buildSectionHeader('Timer Configuration'),
          _buildDurationTile(
            ref,
            'Focus Duration',
            'focus',
            timerSettings['focus']!,
            Icons.timer_outlined,
          ),
          _buildDurationTile(
            ref,
            'Short Break',
            'shortBreak',
            timerSettings['shortBreak']!,
            Icons.coffee_outlined,
          ),
          _buildDurationTile(
            ref,
            'Long Break',
            'longBreak',
            timerSettings['longBreak']!,
            Icons.hotel_outlined,
          ),
          const Divider(),
          _buildSectionHeader('Audio & Haptics'),
          SwitchListTile(
            title: const Text('Sound Effects'),
            subtitle: const Text('Play sound when timer ends'),
            value: true,
            onChanged: (v) {},
            secondary: const Icon(Icons.volume_up_outlined),
          ),
          SwitchListTile(
            title: const Text('Haptic Feedback'),
            subtitle: const Text('Vibrate on interactions'),
            value: true,
            onChanged: (v) {},
            secondary: const Icon(Icons.vibration_outlined),
          ),
          const Divider(),
          _buildSectionHeader('Account'),
          ListTile(
            leading: const Icon(Icons.login_outlined),
            title: const Text('Sign In'),
            subtitle: const Text('Sync your data across devices'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          _buildSectionHeader('Support'),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Feedback'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About FocusFlow'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () {},
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
    );
  }

  Widget _buildDurationTile(
    WidgetRef ref,
    String title,
    String key,
    int value,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 20),
            onPressed: () {
              if (value > 1) {
                ref.read(timerSettingsProvider.notifier).updateDuration(key, value - 1);
              }
            },
          ),
          Text('$value min', style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 20),
            onPressed: () {
              ref.read(timerSettingsProvider.notifier).updateDuration(key, value + 1);
            },
          ),
        ],
      ),
    );
  }
}
