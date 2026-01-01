import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../main.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final Map<String, dynamic> _userData = {};

  final List<OnboardingQuestion> _questions = [
    OnboardingQuestion(
      title: 'سلام! خوش اومدی 🎉',
      question: 'اسم کوچیکت چیه؟ چی صدات کنم؟',
      emoji: '👋',
      type: QuestionType.text,
      hint: 'اسم من...',
      dataKey: 'name',
    ),
    OnboardingQuestion(
      title: 'بیشتر بشناسمت 😊',
      question: 'چند سالته حدوداً؟',
      emoji: '🎂',
      type: QuestionType.choice,
      dataKey: 'age',
      options: AppConstants.ageGroups,
    ),
    OnboardingQuestion(
      title: 'فعالیت روزانه 💼',
      question: 'روزانه بیشتر چیکار می‌کنی؟',
      emoji: '🎯',
      type: QuestionType.choice,
      dataKey: 'activity',
      options: AppConstants.activities,
    ),
    OnboardingQuestion(
      title: 'برای فال شخصی‌تر 📖',
      question: 'ماه تولدت چیه؟',
      emoji: '🌙',
      type: QuestionType.choice,
      dataKey: 'birthMonth',
      options: AppConstants.persianMonths,
    ),
    OnboardingQuestion(
      title: 'آب‌وهوا و پیشنهاد محلی 🌤️',
      question: 'شهر یا استانت کجاست؟',
      emoji: '📍',
      type: QuestionType.text,
      hint: 'مثلاً: تهران',
      dataKey: 'city',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finishOnboarding() async {
    final appState = context.read<AppStateProvider>();
    await appState.saveUserProfile(_userData);
    
    if (!mounted) return;
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: List.generate(
                    _questions.length,
                    (index) => Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: index <= _currentPage
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ).animate(target: index <= _currentPage ? 1 : 0)
                        .scaleX(duration: 300.ms, alignment: Alignment.centerRight),
                    ),
                  ),
                ),
              ),
              
              // Questions
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    return _buildQuestionPage(_questions[index]);
                  },
                ),
              ),
              
              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      IconButton(
                        onPressed: _previousPage,
                        icon: const Icon(Icons.arrow_back_rounded),
                        iconSize: 32,
                        color: theme.colorScheme.primary,
                      ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        final question = _questions[_currentPage];
                        if (_userData[question.dataKey] != null &&
                            _userData[question.dataKey].toString().isNotEmpty) {
                          _nextPage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentPage == _questions.length - 1
                                ? 'بزن بریم! 🚀'
                                : 'بعدی',
                            style: const TextStyle(fontSize: 18),
                          ),
                          if (_currentPage < _questions.length - 1)
                            const SizedBox(width: 8),
                          if (_currentPage < _questions.length - 1)
                            const Icon(Icons.arrow_forward_rounded),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionPage(OnboardingQuestion question) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // Emoji
          Text(
            question.emoji,
            style: const TextStyle(fontSize: 80),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(delay: 200.ms)
              .then()
              .shake(duration: 500.ms),
          
          const SizedBox(height: 30),
          
          // Title
          Text(
            question.title,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
          
          const SizedBox(height: 20),
          
          // Question
          Text(
            question.question,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 18,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
          
          const SizedBox(height: 50),
          
          // Input
          if (question.type == QuestionType.text)
            _buildTextInput(question)
          else
            _buildChoiceInput(question),
        ],
      ),
    );
  }

  Widget _buildTextInput(OnboardingQuestion question) {
    return TextField(
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        hintText: question.hint,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
      ),
      onChanged: (value) {
        setState(() {
          _userData[question.dataKey] = value;
        });
      },
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildChoiceInput(OnboardingQuestion question) {
    final theme = Theme.of(context);
    
    return Column(
      children: question.options!.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = _userData[question.dataKey] == option;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () {
                setState(() {
                  _userData[question.dataKey] = option;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(delay: (500 + index * 100).ms)
            .slideX(begin: 0.3, end: 0);
      }).toList(),
    );
  }
}

enum QuestionType { text, choice }

class OnboardingQuestion {
  final String title;
  final String question;
  final String emoji;
  final QuestionType type;
  final String? hint;
  final List<String>? options;
  final String dataKey;

  OnboardingQuestion({
    required this.title,
    required this.question,
    required this.emoji,
    required this.type,
    this.hint,
    this.options,
    required this.dataKey,
  });
}