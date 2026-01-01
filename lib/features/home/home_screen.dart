import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../widgets/floating_icons.dart';
import '../../core/theme/app_theme.dart';
import '../chat/chat_screen.dart';
import '../hafez/hafez_screen.dart';
import '../tasks/tasks_screen.dart';
import '../morning/morning_mana_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _showFloatingIcon = true;
  late AnimationController _floatingIconController;

  @override
  void initState() {
    super.initState();
    _floatingIconController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatingIconController.dispose();
    super.dispose();
  }

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ChatScreen(),
    const HafezScreen(),
    const TasksScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppStateProvider>();
    
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          _screens[_selectedIndex],
          
          // Floating Icon
          if (_showFloatingIcon)
            Positioned(
              bottom: 100,
              right: 20,
              child: _buildFloatingIcon(appState),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(theme),
    );
  }

  Widget _buildFloatingIcon(AppStateProvider appState) {
    FloatingIconType iconType;
    switch (appState.floatingIconType) {
      case 'dog':
        iconType = FloatingIconType.dog;
        break;
      case 'cloud':
        iconType = FloatingIconType.cloud;
        break;
      case 'moon':
        iconType = FloatingIconType.moon;
        break;
      case 'star':
        iconType = FloatingIconType.star;
        break;
      default:
        iconType = FloatingIconType.cat;
    }

    return Draggable(
      feedback: Opacity(
        opacity: 0.8,
        child: FloatingIconWidget(
          iconType: iconType,
          size: appState.floatingIconSize,
          isPulsing: true,
          primaryColor: Theme.of(context).colorScheme.primary,
          secondaryColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
      childWhenDragging: const SizedBox.shrink(),
      onDragEnd: (details) {
        // Save position if needed
      },
      child: FloatingIconWidget(
        iconType: iconType,
        size: appState.floatingIconSize,
        isPulsing: true,
        primaryColor: Theme.of(context).colorScheme.primary,
        secondaryColor: Theme.of(context).colorScheme.secondary,
        onTap: () {
          // Single tap - open quick action menu
          _showQuickMenu();
        },
        onDoubleTap: () {
          // Double tap - open chat directly
          setState(() => _selectedIndex = 1);
        },
        onLongPress: () {
          // Long press - open morning mana or custom action
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MorningManaScreen()),
          );
        },
      ),
    );
  }

  void _showQuickMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withOpacity(0.9),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'چیکار می‌خوای بکنم؟ 😊',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 24),
            _buildQuickMenuItem(
              Icons.chat_bubble_rounded,
              'چت با مانا',
              () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 1);
              },
            ),
            _buildQuickMenuItem(
              Icons.wb_sunny_rounded,
              'صبحانه مانا',
              () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MorningManaScreen()),
                );
              },
            ),
            _buildQuickMenuItem(
              Icons.auto_stories_rounded,
              'فال حافظ',
              () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 2);
              },
            ),
            _buildQuickMenuItem(
              Icons.task_alt_rounded,
              'کارهای امروز',
              () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 3);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.dashboard_rounded, 'خانه', 0),
              _buildNavItem(Icons.chat_bubble_rounded, 'چت', 1),
              _buildNavItem(Icons.auto_stories_rounded, 'فال', 2),
              _buildNavItem(Icons.task_alt_rounded, 'کارها', 3),
              _buildNavItem(Icons.settings_rounded, 'تنظیمات', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.white60,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.white60,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    ).animate(target: isSelected ? 1 : 0).scale(duration: 200.ms);
  }
}

// Dashboard Screen
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppStateProvider>();
    final userName = appState.userProfile['name'] ?? 'کاربر';
    
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'M',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'سلام $userName! 👋',
                          style: theme.textTheme.displayMedium,
                        ),
                        Text(
                          'امروز چیکار می‌خوای بکنی؟',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn().slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 30),
              
              // Quick Actions
              _buildQuickActions(context),
              
              const SizedBox(height: 30),
              
              // Today's Summary
              _buildTodaySummary(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'دسترسی سریع',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildActionCard(
              context,
              'صبحانه مانا',
              '🌅',
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MorningManaScreen())),
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildActionCard(
              context,
              'فال حافظ',
              '📖',
              () {},
            )),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildActionCard(BuildContext context, String title, String emoji, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodaySummary(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خلاصه امروز',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(Icons.task_alt, '3 کار انجام شده', Colors.green),
            const SizedBox(height: 12),
            _buildSummaryRow(Icons.shopping_cart, '2 آیتم در لیست خرید', Colors.orange),
            const SizedBox(height: 12),
            _buildSummaryRow(Icons.note_alt, '5 یادداشت جدید', Colors.blue),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildSummaryRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}