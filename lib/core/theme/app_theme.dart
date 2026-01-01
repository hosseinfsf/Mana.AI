import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // 5 تم مختلف
  static const List<ThemeData> themes = [
    _magicalPurpleGold,
    _oceanBlue,
    _forestGreen,
    _sunsetOrange,
    _midnightBlack,
  ];
  
  static const List<String> themeNames = [
    'جادوی بنفش 🔮',
    'اقیانوس آبی 🌊',
    'جنگل سبز 🌲',
    'غروب نارنجی 🌅',
    'شب مهتابی 🌙',
  ];
}

// تم 1: جادوی بنفش-طلایی (پیش‌فرض)
const _magicalPurpleGold = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF0F0A1F),
  primaryColor: Color(0xFF7C3AED),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF7C3AED), // بنفش عمیق
    secondary: Color(0xFFEAB308), // طلایی
    tertiary: Color(0xFFEC4899), // صورتی
    surface: Color(0xFF1A1528),
    background: Color(0xFF0F0A1F),
    error: Color(0xFFEF4444),
    onPrimary: Colors.white,
    onSecondary: Color(0xFF1A1528),
    onSurface: Colors.white,
    onBackground: Colors.white,
  ),
  cardTheme: CardTheme(
    elevation: 8,
    shadowColor: Color(0xFF7C3AED).withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    color: Color(0xFF1A1528).withOpacity(0.6),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Vazir',
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF7C3AED),
    foregroundColor: Colors.white,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Vazir',
      shadows: [
        Shadow(
          color: Color(0xFF7C3AED).withOpacity(0.5),
          blurRadius: 10,
        ),
      ],
    ),
    displayMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Vazir',
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontFamily: 'Vazir',
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Colors.white70,
      fontFamily: 'Vazir',
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF1A1528).withOpacity(0.6),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Color(0xFF7C3AED)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Color(0xFF7C3AED).withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Color(0xFF7C3AED), width: 2),
    ),
    hintStyle: TextStyle(color: Colors.white38),
    prefixIconColor: Color(0xFFEAB308),
    suffixIconColor: Color(0xFFEAB308),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF7C3AED),
      foregroundColor: Colors.white,
      elevation: 8,
      shadowColor: Color(0xFF7C3AED).withOpacity(0.5),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Vazir',
      ),
    ),
  ),
);

// تم 2: اقیانوس آبی
const _oceanBlue = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF0A1929),
  primaryColor: Color(0xFF0EA5E9),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF0EA5E9),
    secondary: Color(0xFF06B6D4),
    tertiary: Color(0xFF3B82F6),
    surface: Color(0xFF1E293B),
    background: Color(0xFF0A1929),
  ),
);

// تم 3: جنگل سبز
const _forestGreen = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF0A1F0A),
  primaryColor: Color(0xFF10B981),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF10B981),
    secondary: Color(0xFF14B8A6),
    tertiary: Color(0xFF84CC16),
    surface: Color(0xFF1A2E1A),
    background: Color(0xFF0A1F0A),
  ),
);

// تم 4: غروب نارنجی
const _sunsetOrange = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF1F0F0A),
  primaryColor: Color(0xFFF97316),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFFF97316),
    secondary: Color(0xFFFBBF24),
    tertiary: Color(0xFFEF4444),
    surface: Color(0xFF2E1A1A),
    background: Color(0xFF1F0F0A),
  ),
);

// تم 5: شب مهتابی
const _midnightBlack = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF000000),
  primaryColor: Color(0xFF6366F1),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF6366F1),
    secondary: Color(0xFF8B5CF6),
    tertiary: Color(0xFFA855F7),
    surface: Color(0xFF1A1A1A),
    background: Color(0xFF000000),
  ),
);

// Gradient Helpers
class AppGradients {
  static const purpleGold = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFEAB308)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const oceanWave = LinearGradient(
    colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const forestLight = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF84CC16)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const sunsetGlow = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const moonlight = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static List<LinearGradient> allGradients = [
    purpleGold,
    oceanWave,
    forestLight,
    sunsetGlow,
    moonlight,
  ];
}