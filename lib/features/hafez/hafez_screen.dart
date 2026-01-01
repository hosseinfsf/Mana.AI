import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../core/services/gemini_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/constants/app_constants.dart';
import '../../main.dart';

class HafezScreen extends StatefulWidget {
  const HafezScreen({Key? key}) : super(key: key);

  @override
  State<HafezScreen> createState() => _HafezScreenState();
}

class _HafezScreenState extends State<HafezScreen> with TickerProviderStateMixin {
  String? _currentPoem;
  String? _interpretation;
  bool _isLoading = false;
  bool _showInterpretation = false;
  late AnimationController _bookController;
  final TextEditingController _questionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bookController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _loadLastHafez();
  }

  Future<void> _loadLastHafez() async {
    final storage = context.read<StorageService>();
    final lastHafez = storage.getLastHafez();
    
    if (lastHafez != null) {
      setState(() {
        _currentPoem = lastHafez['poem'];
        _interpretation = lastHafez['interpretation'];
        _showInterpretation = true;
      });
    }
  }

  Future<void> _getFal() async {
    setState(() {
      _isLoading = true;
      _showInterpretation = false;
    });

    _bookController.forward(from: 0);

    // Random poem selection
    final random = Random();
    final selectedPoem = AppConstants.hafezPoems[
      random.nextInt(AppConstants.hafezPoems.length)
    ];

    setState(() {
      _currentPoem = selectedPoem['poem'];
    });

    try {
      final gemini = context.read<GeminiService>();
      final appState = context.read<AppStateProvider>();
      final userProfile = appState.userProfile;

      final interpretation = await gemini.interpretHafez(
        selectedPoem['poem']!,
        userName: userProfile['name'],
        userQuestion: _questionController.text.isNotEmpty 
            ? _questionController.text 
            : null,
        userAge: userProfile['age'] != null 
            ? int.tryParse(userProfile['age']!) 
            : null,
        birthMonth: userProfile['birthMonth'],
      );

      setState(() {
        _interpretation = interpretation;
        _showInterpretation = true;
        _isLoading = false;
      });

      // Save to storage
      final storage = context.read<StorageService>();
      await storage.saveLastHafez({
        'poem': _currentPoem!,
        'interpretation': interpretation,
      });

      _questionController.clear();
    } catch (e) {
      setState(() {
        _interpretation = 'متأسفم، نتونستم فالت رو تفسیر کنم 😔';
        _showInterpretation = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.auto_stories_rounded,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'فال حافظ',
                            style: theme.textTheme.displayLarge?.copyWith(fontSize: 32),
                          ),
                          Text(
                            'با تفسیر هوشمند مانا 🔮',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn().slideX(begin: -0.3, end: 0),
                
                const SizedBox(height: 30),
                
                // Question input
                if (_currentPoem == null)
                  _buildQuestionInput(theme),
                
                const SizedBox(height: 30),
                
                // Book animation
                _buildBookAnimation(),
                
                const SizedBox(height: 30),
                
                // Get Fal button
                if (!_isLoading && _currentPoem == null)
                  _buildFalButton(theme),
                
                // Poem display
                if (_currentPoem != null)
                  _buildPoemCard(theme),
                
                const SizedBox(height: 20),
                
                // Interpretation
                if (_showInterpretation && _interpretation != null)
                  _buildInterpretationCard(theme),
                
                // Get new Fal button
                if (_currentPoem != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton.icon(
                      onPressed: _getFal,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('فال جدید بگیر'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionInput(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help_outline_rounded, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'سوالت چیه؟ (اختیاری)',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _questionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'سوالت رو بنویس تا فال شخصی‌تر بشه...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildBookAnimation() {
    return AnimatedBuilder(
      animation: _bookController,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_bookController.value * pi),
          child: Container(
            width: 200,
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.auto_stories_rounded,
                size: 80,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFalButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: _getFal,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
        shape: RoundedRectangleBor der(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_fix_high_rounded, size: 28),
          const SizedBox(width: 12),
          const Text(
            'فال بگیر',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).scale(delay: 400.ms);
  }

  Widget _buildPoemCard(ThemeData theme) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  'غزل حافظ',
                  style: theme.textTheme.displayMedium?.copyWith(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _currentPoem!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                height: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildInterpretationCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology_rounded,
                  color: theme.colorScheme.secondary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'تفسیر مانا',
                  style: theme.textTheme.displayMedium?.copyWith(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _interpretation!,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3, end: 0);
  }

  @override
  void dispose() {
    _bookController.dispose();
    _questionController.dispose();
    super.dispose();
  }
}
