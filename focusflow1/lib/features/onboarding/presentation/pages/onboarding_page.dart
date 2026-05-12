import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _items = [
    OnboardingData(
      title: 'Focus on what matters',
      description: 'Master your time with the Pomodoro technique and boost your productivity.',
      icon: Icons.timer_outlined,
      color: const Color(0xFF6366F1),
    ),
    OnboardingData(
      title: 'Track your progress',
      description: 'See your daily achievements and maintain your focus streaks.',
      icon: Icons.bar_chart_outlined,
      color: const Color(0xFF10B981),
    ),
    OnboardingData(
      title: 'Stay organized',
      description: 'Manage your tasks and habits in one beautiful place.',
      icon: Icons.checklist_outlined,
      color: const Color(0xFFF59E0B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return _OnboardingView(data: _items[index]);
            },
          ),
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _items.length,
                    (index) => _buildIndicator(index == _currentPage),
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _items.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.go('/home');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _items[_currentPage].color,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      _currentPage == _items.length - 1 ? 'Get Started' : 'Next',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Skip'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? _items[_currentPage].color : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _OnboardingView extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingView({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            data.icon,
            size: 120,
            color: data.color,
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack).fadeIn(),
          const SizedBox(height: 60),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
          const SizedBox(height: 16),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }
}
