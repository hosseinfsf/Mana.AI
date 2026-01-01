import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'مانا دستیار';
  static const String appSlogan = 'با مانا، هوشمندانه زندگی کن';
  static const String appVersion = '1.0.0';
  
  // API Keys (باید توی .env بذاری)
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
  
  // Floating Icon Sizes
  static const double floatingIconMinSize = 60.0;
  static const double floatingIconMaxSize = 120.0;
  static const double floatingIconDefaultSize = 80.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  static const Duration pulseInterval = Duration(seconds: 5);
  
  // Storage Keys
  static const String keyFirstLaunch = 'first_launch';
  static const String keyUserName = 'user_name';
  static const String keyUserAge = 'user_age';
  static const String keyUserActivity = 'user_activity';
  static const String keyUserBirthMonth = 'user_birth_month';
  static const String keyUserCity = 'user_city';
  static const String keyCurrentTheme = 'current_theme';
  static const String keyFloatingIconType = 'floating_icon_type';
  static const String keyFloatingIconSize = 'floating_icon_size';
  static const String keyFloatingIconOpacity = 'floating_icon_opacity';
  static const String keyChatHistory = 'chat_history';
  static const String keyTasks = 'tasks';
  static const String keyShoppingList = 'shopping_list';
  static const String keyNotes = 'notes';
  static const String keyLastHafez = 'last_hafez';
  
  // Hafez Poems (نمونه - باید کامل بشه)
  static const List<Map<String, String>> hafezPoems = [
    {
      'poem': 'الا یا ایها الساقی ادر کاسا و ناولها\nکه عشق آسان نمود اول ولی افتاد مشکل‌ها',
      'interpretation': 'این غزل درباره شروع آسان عشق و دشواری‌های بعدی آن است...'
    },
    {
      'poem': 'صلاح کار کجا و من خراب کجا\nببین تفاوت ره کز کجاست تا به کجا',
      'interpretation': 'حافظ از تفاوت راه خود با اهل صلاح می‌گوید...'
    },
    // Add more poems...
  ];
  
  // Age Groups
  static const List<String> ageGroups = [
    'زیر ۱۸ سال',
    '۱۸ تا ۲۵ سال',
    '۲۶ تا ۳۵ سال',
    '۳۶ تا ۵۰ سال',
    'بالای ۵۰ سال',
  ];
  
  // Activities
  static const List<String> activities = [
    'دانشجو 📚',
    'کارمند 💼',
    'خانه‌دار 🏠',
    'فریلنسر 💻',
    'بازنشسته 🌴',
    'سایر موارد ✨',
  ];
  
  // Persian Months
  static const List<String> persianMonths = [
    'فروردین', 'اردیبهشت', 'خرداد', 'تیر',
    'مرداد', 'شهریور', 'مهر', 'آبان',
    'آذر', 'دی', 'بهمن', 'اسفند',
  ];
  
  // Chat Tones
  static const List<Map<String, dynamic>> chatTones = [
    {'name': 'دوستانه', 'emoji': '😊', 'key': 'friendly'},
    {'name': 'رسمی', 'emoji': '🎩', 'key': 'formal'},
    {'name': 'طنز', 'emoji': '😄', 'key': 'funny'},
    {'name': 'حرفه‌ای', 'emoji': '💼', 'key': 'professional'},
    {'name': 'عاشقانه', 'emoji': '💕', 'key': 'romantic'},
  ];
  
  // Social Media Response Types
  static const List<String> socialResponseTypes = [
    'پاسخ دوستانه',
    'پاسخ رسمی',
    'پاسخ طنز',
    'پاسخ کوتاه',
    'پاسخ تشکر',
  ];
  
  // Content Generation Types
  static const List<Map<String, dynamic>> contentTypes = [
    {'name': 'کپشن اینستاگرام', 'emoji': '📸', 'key': 'instagram_caption'},
    {'name': 'متن توییتر', 'emoji': '🐦', 'key': 'twitter_post'},
    {'name': 'پست لینکدین', 'emoji': '💼', 'key': 'linkedin_post'},
    {'name': 'بیو پروفایل', 'emoji': '✨', 'key': 'profile_bio'},
    {'name': 'هشتگ', 'emoji': '#️⃣', 'key': 'hashtags'},
  ];
  
  // Task Priorities
  static const List<Map<String, dynamic>> taskPriorities = [
    {'name': 'کم', 'color': Colors.green, 'icon': Icons.flag_outlined},
    {'name': 'متوسط', 'color': Colors.orange, 'icon': Icons.flag},
    {'name': 'زیاد', 'color': Colors.red, 'icon': Icons.outlined_flag},
  ];
  
  // Morning Mana Sections (قابل تنظیم توسط کاربر)
  static const List<Map<String, dynamic>> morningManaSections = [
    {'key': 'weather', 'name': 'آب و هوا', 'emoji': '🌤️', 'enabled': true},
    {'key': 'hafez', 'name': 'فال حافظ', 'emoji': '📖', 'enabled': true},
    {'key': 'tasks', 'name': 'کارهای امروز', 'emoji': '✅', 'enabled': true},
    {'key': 'occasions', 'name': 'مناسبت‌ها', 'emoji': '🎉', 'enabled': true},
    {'key': 'sports', 'name': 'اخبار ورزشی', 'emoji': '⚽', 'enabled': false},
    {'key': 'quote', 'name': 'جمله انگیزشی', 'emoji': '💪', 'enabled': true},
  ];
}
