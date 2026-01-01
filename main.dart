import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'core/theme/app_theme.dart';
import 'core/services/storage_service.dart';
import 'core/services/gemini_service.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/home/home_screen.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تنظیمات سیستم
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Initialize services
  final storage = await StorageService.getInstance();
  final gemini = GeminiService();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storage),
        Provider<GeminiService>.value(value: gemini),
        ChangeNotifierProvider(create: (_) => AppStateProvider(storage)),
      ],
      child: const ManaApp(),
    ),
  );
}

class ManaApp extends StatelessWidget {
  const ManaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, _) {
        return MaterialApp(
          title: 'مانا دستیار',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themes[appState.currentTheme],
          home: const SplashScreen(),
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
        );
      },
    );
  }
}

// State Management
class AppStateProvider extends ChangeNotifier {
  final StorageService _storage;
  
  int _currentTheme = 0;
  String _floatingIconType = 'cat';
  double _floatingIconSize = 80.0;
  double _floatingIconOpacity = 1.0;
  Map<String, String> _userProfile = {};
  
  AppStateProvider(this._storage) {
    _loadSettings();
  }
  
  int get currentTheme => _currentTheme;
  String get floatingIconType => _floatingIconType;
  double get floatingIconSize => _floatingIconSize;
  double get floatingIconOpacity => _floatingIconOpacity;
  Map<String, String> get userProfile => _userProfile;
  
  void _loadSettings() {
    _currentTheme = _storage.getCurrentTheme();
    _floatingIconType = _storage.getFloatingIconType();
    _floatingIconSize = _storage.getFloatingIconSize();
    _floatingIconOpacity = _storage.getFloatingIconOpacity();
    _userProfile = _storage.getUserProfile();
    notifyListeners();
  }
  
  Future<void> setTheme(int themeIndex) async {
    _currentTheme = themeIndex;
    await _storage.saveTheme(themeIndex);
    notifyListeners();
  }
  
  Future<void> setFloatingIconType(String type) async {
    _floatingIconType = type;
    await _storage.saveFloatingIconType(type);
    notifyListeners();
  }
  
  Future<void> setFloatingIconSize(double size) async {
    _floatingIconSize = size;
    await _storage.saveFloatingIconSize(size);
    notifyListeners();
  }
  
  Future<void> setFloatingIconOpacity(double opacity) async {
    _floatingIconOpacity = opacity;
    await _storage.saveFloatingIconOpacity(opacity);
    notifyListeners();
  }
  
  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    _userProfile = profile.map((key, value) => MapEntry(key, value.toString()));
    await _storage.saveUserProfile(profile);
    notifyListeners();
  }
}