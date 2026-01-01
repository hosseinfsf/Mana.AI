import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../../core/services/gemini_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/constants/app_constants.dart';
import '../../main.dart';

class MorningManaScreen extends StatefulWidget {
  const MorningManaScreen({Key? key}) : super(key: key);

  @override
  State<MorningManaScreen> createState() => _MorningManaScreenState();
}

class _MorningManaScreenState extends State<MorningManaScreen> {
  bool _isLoading = true;
  String? _morningMessage;
  String? _hafezPoem;
  List<String> _todayTasks = [];
  
  @override
  void initState() {
    super.initState();
    _generateMorningMana();
  }

  Future<void> _generateMorningMana() async {
    setState(() => _isLoading = true);
    
    try {
      final gemini = context.read<GeminiService>();
      final storage = context.read<StorageService>();
      final appState = context.read<AppStateProvider>();
      
      // Get user info
      final userName = appState.userProfile['name'] ?? 'کاربر';
      
      // Get today's tasks
      final tasks = storage.getTasks();
      _todayTasks = tasks
          .where((t) => t['isCompleted'] == false)
          .take(5)
          .map((t) => t['title'].toString())
          .toList();
      
      // Get random Hafez poem
      final random = Random();
      final hafezData = AppConstants.hafezPoems[
        random.nextInt(AppConstants.hafezPoems.length)
      ];
      _hafezPoem = hafezData['poem'];
      
      // Generate morning message
      final message = await gemini.generateMorningMana(
        userName: userName,
        weather: 'آفتابی ☀️', // باید از API بگیری
        todayTasks: _todayTasks,
        hafezPoem: _hafezPoem!,
      );
      
      setState(() {
        _morningMessage = message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _morningMessage = 'صبح بخیر! امروز روز فوق‌العاده‌ای میشه! 🌟';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppStateProvider>();
    final userName = appState.userProfile['name'] ?? 'کاربر';
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
              theme.colorScheme.tertiary,
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? _buildLoadingState()
              : _buildContent(userName),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wb_sunny_rounded,
            size: 80,
            color: Colors.white,
          ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1500.ms, color: Colors.white)
            .rotate(duration: 3000.ms),
          const SizedBox(height: 30),
          const Text(
            'صبر کن، دارم آماده می‌کنم... ☕',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String userName) {
    final now = DateTime.now();
    final persianDate = 'امروز ${_getPersianWeekday(now.weekday)}';
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                ),
                IconButton(
                  onPressed: _generateMorningMana,
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                ),
              ],
            ),
          ),
          
          // Main greeting
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Text(
                  '🌅',
                  style: const TextStyle(fontSize: 80),
                ).animate().fadeIn().scale().shimmer(duration: 1500.ms),
                
                const SizedBox(height: 20),
                
                Text(
                  'صبح بخیر $userName! ✨',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.3, end: 0),
                
                const SizedBox(height: 10),
                
                Text(
                  persianDate,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ).animate().fadeIn(delay: 400.ms),
              ],
            ),
          ),
          
          // Cards
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Weather card
                  _buildCard(
                    icon: Icons.wb_sunny_rounded,
                    title: 'آب و هوا امروز',
                    content: 'آفتابی و خنک ☀️\nدمای ۲۵ درجه',
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.yellow],
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, end: 0),
                  
                  const SizedBox(height: 16),
                  
                  // Hafez card
                  if (_hafezPoem != null)
                    _buildCard(
                      icon: Icons.auto_stories_rounded,
                      title: 'فال حافظ امروز 📖',
                      content: _hafezPoem!,
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.pink],
                      ),
                    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.3, end: 0),
                  
                  const SizedBox(height: 16),
                  
                  // Tasks card
                  _buildCard(
                    icon: Icons.task_alt_rounded,
                    title: 'کارهای امروز ✅',
                    content: _todayTasks.isEmpty
                        ? 'هیچ کاری نداری! یه روز آزاد 🎉'
                        : _todayTasks.take(3).map((t) => '• $t').join('\n'),
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.cyan],
                    ),
                  ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3, end: 0),
                  
                  const SizedBox(height: 16),
                  
                  // Morning message
                  if (_morningMessage != null)
                    _buildCard(
                      icon: Icons.psychology_rounded,
                      title: 'پیام مانا 💪',
                      content: _morningMessage!,
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.teal],
                      ),
                    ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.3, end: 0),
                  
                  const SizedBox(height: 30),
                  
                  // Action button
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'بزن بریم! 🚀',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ).animate().fadeIn(delay: 1000.ms).scale(delay: 1000.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String content,
    required LinearGradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  String _getPersianWeekday(int weekday) {
    const weekdays = [
      'دوشنبه',
      'سه‌شنبه',
      'چهارشنبه',
      'پنج‌شنبه',
      'جمعه',
      'شنبه',
      'یکشنبه',
    ];
    return weekdays[weekday - 1];
  }
}
