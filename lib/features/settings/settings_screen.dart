import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/floating_icons.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppStateProvider>();
    
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
                  Icon(
                    Icons.settings_rounded,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تنظیمات',
                          style: theme.textTheme.displayLarge?.copyWith(fontSize: 28),
                        ),
                        Text(
                          'شخصی‌سازی مانا',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn().slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 30),
              
              // Profile section
              _buildSection(
                'پروفایل کاربری',
                [
                  _buildProfileTile(context, appState),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Theme section
              _buildSection(
                'تم و ظاهر',
                [
                  _buildThemeSelector(context, appState),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Floating icon section
              _buildSection(
                'آیکون شناور',
                [
                  _buildFloatingIconSelector(context, appState),
                  _buildFloatingIconSizeSlider(context, appState),
                  _buildFloatingIconOpacitySlider(context, appState),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // About section
              _buildSection(
                'درباره',
                [
                  _buildAboutTile(context),
                  _buildVersionTile(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, right: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
        ...children,
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildProfileTile(BuildContext context, AppStateProvider appState) {
    final profile = appState.userProfile;
    final name = profile['name'] ?? 'کاربر';
    
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'M',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(name),
        subtitle: Text(profile['activity'] ?? 'کاربر مانا'),
        trailing: const Icon(Icons.edit_rounded),
        onTap: () {
          // TODO: Edit profile
        },
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, AppStateProvider appState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'انتخاب تم',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: AppTheme.themes.length,
                itemBuilder: (context, index) {
                  final isSelected = appState.currentTheme == index;
                  final gradient = AppGradients.allGradients[index];
                  
                  return GestureDetector(
                    onTap: () => appState.setTheme(index),
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Colors.white
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: gradient.colors.first.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_circle_rounded
                                  : Icons.circle_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppTheme.themeNames[index].split(' ')[1],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate(target: isSelected ? 1 : 0)
                    .scale(duration: 200.ms);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingIconSelector(BuildContext context, AppStateProvider appState) {
    final iconTypes = ['cat', 'dog', 'cloud', 'moon', 'star'];
    final iconNames = ['گربه 🐱', 'سگ 🐶', 'ابر ☁️', 'ماه 🌙', 'ستاره ⭐'];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'شکل آیکون',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: iconTypes.length,
                itemBuilder: (context, index) {
                  final type = iconTypes[index];
                  final isSelected = appState.floatingIconType == type;
                  
                  FloatingIconType iconType;
                  switch (type) {
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
                  
                  return GestureDetector(
                    onTap: () => appState.setFloatingIconType(type),
                    child: Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: FloatingIconWidget(
                              iconType: iconType,
                              size: 50,
                              isPulsing: isSelected,
                              primaryColor: Theme.of(context).colorScheme.primary,
                              secondaryColor: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            iconNames[index],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white60,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate(target: isSelected ? 1 : 0)
                    .scale(duration: 200.ms);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingIconSizeSlider(BuildContext context, AppStateProvider appState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'اندازه آیکون',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${appState.floatingIconSize.toInt()}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Slider(
              value: appState.floatingIconSize,
              min: AppConstants.floatingIconMinSize,
              max: AppConstants.floatingIconMaxSize,
              divisions: 12,
              label: appState.floatingIconSize.toInt().toString(),
              onChanged: (value) => appState.setFloatingIconSize(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingIconOpacitySlider(BuildContext context, AppStateProvider appState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'شفافیت آیکون',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(appState.floatingIconOpacity * 100).toInt()}%',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Slider(
              value: appState.floatingIconOpacity,
              min: 0.3,
              max: 1.0,
              divisions: 7,
              label: '${(appState.floatingIconOpacity * 100).toInt()}%',
              onChanged: (value) => appState.setFloatingIconOpacity(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.info_outline_rounded, color: Theme.of(context).colorScheme.primary),
        title: const Text('درباره مانا'),
        subtitle: const Text('دستیار هوشمند زندگی'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('درباره مانا 🤖'),
              content: const Text(
                'مانا یک دستیار هوشمند همه‌کاره است که با استفاده از هوش مصنوعی به شما کمک می‌کند زندگی راحت‌تری داشته باشید.\n\n'
                'با مانا، هوشمندانه زندگی کن! ✨',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('باشه'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVersionTile() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.code_rounded, color: Colors.white60),
        title: const Text('نسخه'),
        subtitle: Text(AppConstants.appVersion),
      ),
    );
  }
}
