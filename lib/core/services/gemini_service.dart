import 'package:google_generative_ai/google_generative_ai.dart';
import '../constants/app_constants.dart';

class GeminiService {
  static GeminiService? _instance;
  late GenerativeModel _model;
  
  GeminiService._() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: AppConstants.geminiApiKey,
    );
  }
  
  factory GeminiService() {
    _instance ??= GeminiService._();
    return _instance!;
  }
  
  // چت ساده
  Future<String> chat(String message, {String? userName, String? tone}) async {
    try {
      final prompt = _buildPrompt(message, userName: userName, tone: tone);
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'متأسفم، نتونستم جواب بدم 😔';
    } catch (e) {
      return 'خطا در ارتباط با سرور: ${e.toString()}';
    }
  }
  
  // چت با تاریخچه
  Future<String> chatWithHistory(
    String message,
    List<Map<String, String>> history, {
    String? userName,
    String? tone,
  }) async {
    try {
      final chat = _model.startChat(history: _convertHistory(history));
      final prompt = _buildPrompt(message, userName: userName, tone: tone);
      final response = await chat.sendMessage(Content.text(prompt));
      return response.text ?? 'متأسفم، نتونستم جواب بدم 😔';
    } catch (e) {
      return 'خطا: ${e.toString()}';
    }
  }
  
  // تفسیر فال حافظ
  Future<String> interpretHafez(
    String poem, {
    String? userName,
    String? userQuestion,
    int? userAge,
    String? birthMonth,
  }) async {
    final prompt = '''
شما مانا هستید، یک دستیار هوشمند فارسی‌زبان و متخصص تفسیر اشعار حافظ.
${userName != null ? 'نام کاربر: $userName' : ''}
${userAge != null ? 'سن تقریبی: $userAge' : ''}
${birthMonth != null ? 'ماه تولد: $birthMonth' : ''}
${userQuestion != null ? 'سوال کاربر: $userQuestion' : ''}

این غزل حافظ برای کاربر نمایان شد:
$poem

لطفاً یک تفسیر شخصی‌سازی‌شده، امیدوارکننده و دوستانه بده که:
1. مرتبط با حال و سوال کاربر باشه
2. مثبت و انگیزشی باشه
3. حداکثر 150 کلمه
4. با ایموجی مناسب همراه باشه
5. لحن دوستانه و صمیمی داشته باشه
''';
    
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'تفسیر فال در حال حاضر در دسترس نیست.';
    } catch (e) {
      return 'خطا در تفسیر فال: ${e.toString()}';
    }
  }
  
  // پاسخ به پیام‌های شبکه‌های اجتماعی
  Future<List<String>> generateSocialResponses(
    String message,
    String responseType,
  ) async {
    final prompt = '''
شما مانا هستید، یک دستیار هوشمند برای پاسخ‌دهی به پیام‌ها.

پیام دریافتی:
"$message"

نوع پاسخ درخواستی: $responseType

لطفاً 3 پاسخ مختلف با این مشخصات بده:
1. ${responseType == 'دوستانه' ? 'صمیمی و گرم' : responseType == 'رسمی' ? 'رسمی و محترمانه' : responseType == 'طنز' ? 'شوخ و سرگرم‌کننده' : responseType == 'کوتاه' ? 'خیلی کوتاه (حداکثر 10 کلمه)' : 'تشکرآمیز'}
2. با ایموجی مناسب
3. هر پاسخ در یک خط جداگانه
4. بدون شماره‌گذاری

فقط 3 پاسخ بنویس، هیچ توضیح اضافی ندی.
''';
    
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final text = response.text ?? '';
      return text.split('\n').where((line) => line.trim().isNotEmpty).take(3).toList();
    } catch (e) {
      return [
        'ممنون از پیامت! ❤️',
        'خیلی خوشحالم که پیام دادی 😊',
        'دستت طلا! 🌟',
      ];
    }
  }
  
  // تولید محتوا (کپشن اینستاگرام، بیو و...)
  Future<String> generateContent(
    String contentType,
    String description,
  ) async {
    final prompts = {
      'instagram_caption': '''
یک کپشن جذاب و خلاقانه برای اینستاگرام بنویس درباره: $description

مشخصات:
- حداکثر 150 کلمه
- با ایموجی‌های مناسب
- hashtag مرتبط
- engaging و قابل share
''',
      'twitter_post': '''
یک توییت کوتاه (حداکثر 280 کاراکتر) بنویس درباره: $description
- جذاب و گیرا
- با ایموجی
''',
      'linkedin_post': '''
یک پست حرفه‌ای برای لینکدین بنویس درباره: $description
- رسمی اما جذاب
- مناسب محیط کاری
- با hashtag های مرتبط
''',
      'profile_bio': '''
یک بیو جذاب و کوتاه برای پروفایل بنویس درباره: $description
- حداکثر 50 کلمه
- خلاقانه و به یادماندنی
''',
      'hashtags': '''
10 هشتگ مرتبط و پرطرفدار برای این موضوع پیشنهاد بده: $description
فقط هشتگ‌ها رو بنویس، هیچ توضیح اضافی ندی.
''',
    };
    
    final prompt = prompts[contentType] ?? prompts['instagram_caption']!;
    
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'نتونستم محتوا بسازم 😔';
    } catch (e) {
      return 'خطا: ${e.toString()}';
    }
  }
  
  // تحلیل کلیپ‌بورد
  Future<Map<String, dynamic>> analyzeClipboard(String text) async {
    final prompt = '''
شما مانا هستید، یک دستیار هوشمند کلیپ‌بورد.

متن کپی‌شده:
"$text"

این متن رو تحلیل کن و به این سوالات جواب بده:
1. نوع محتوا چیه؟ (پیام، ایمیل، کپشن، لینک، کد، متن عادی)
2. زبان: فارسی یا انگلیسی؟
3. پیشنهادات: چه کارهایی می‌تونم با این متن انجام بدم؟

جواب رو به صورت JSON بده:
{
  "type": "نوع محتوا",
  "language": "زبان",
  "suggestions": ["پیشنهاد 1", "پیشنهاد 2", "پیشنهاد 3"]
}
''';
    
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final text = response.text ?? '{}';
      // در نسخه واقعی باید JSON parse کنی
      return {
        'type': 'text',
        'language': 'fa',
        'suggestions': ['خلاصه کن', 'ترجمه کن', 'اصلاح کن'],
      };
    } catch (e) {
      return {
        'type': 'unknown',
        'language': 'unknown',
        'suggestions': ['خطا در تحلیل'],
      };
    }
  }
  
  // صبحانه مانا
  Future<String> generateMorningMana({
    required String userName,
    required String weather,
    required List<String> todayTasks,
    required String hafezPoem,
    String? sportsNews,
  }) async {
    final prompt = '''
صبح بخیر $userName! 🌅✨

امروز قراره یه روز فوق‌العاده باشه! بذار خلاصه‌ای از روز بهت بدم:

🌤️ آب و هوا: $weather

📖 فال حافظ امروزت:
$hafezPoem

✅ کارهای امروز (${todayTasks.length} تا کار):
${todayTasks.isEmpty ? 'هیچی نداری! یه روز آزاد داری 🎉' : todayTasks.take(3).map((e) => '• $e').join('\n')}

${sportsNews != null ? '⚽ اخبار ورزشی:\n$sportsNews\n' : ''}

💪 جمله انگیزشی: 

یه پیام انگیزشی کوتاه و پرانرژی (حداکثر 30 کلمه) بنویس که $userName رو شارژ کنه!
از ایموجی استفاده کن و لحنت خیلی دوستانه و شوخ باشه.
''';
    
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'صبح بخیر! امروز روز خوبیه! 🌟';
    } catch (e) {
      return 'صبح بخیر! امروز قراره روز فوق‌العاده‌ای باشه! 💪✨';
    }
  }
  
  // شب‌نامه مانا
  Future<String> generateNightSummary({
    required String userName,
    required int completedTasks,
    required int totalTasks,
  }) async {
    final prompt = '''
شب بخیر $userName! 🌙✨

امروز $completedTasks از $totalTasks تا کارت رو انجام دادی ${completedTasks == totalTasks ? '🎉 آفرین!' : completedTasks > totalTasks / 2 ? '👏 خوب بود!' : '💪 فردا بهتر می‌شه!'}

یه خلاصه دوستانه و مهربون از روز بنویس که:
- تشویق‌کننده باشه
- پیشنهاد یه آهنگ آرام‌بخش بده
- بپرسه امروزش چطور بود
- حداکثر 100 کلمه
- با ایموجی
- خیلی صمیمی و دوستانه
''';
    
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'شب بخیر! بخواب و فردا قوی‌تر برگرد 💪🌙';
    } catch (e) {
      return 'شب بخیر! امروز تلاش کردی و این مهمه. بخواب و فردا روز بهتریه 🌙✨';
    }
  }
  
  // Helper: ساخت پرامپت با شخصیت مانا
  String _buildPrompt(String message, {String? userName, String? tone}) {
    final tonePrompts = {
      'friendly': 'خیلی دوستانه، صمیمی و گرم',
      'formal': 'رسمی اما مهربون',
      'funny': 'شوخ، طنز و سرگرم‌کننده',
      'professional': 'حرفه‌ای و دقیق',
      'romantic': 'عاشقانه و احساسی',
    };
    
    return '''
شما مانا هستید، یک دستیار هوشمند فارسی‌زبان با این مشخصات:
- نام: مانا
- شخصیت: دوست نزدیک کاربر، مهربون، کمی شوخ، حرفه‌ای و سختگیر
- لحن: ${tone != null ? tonePrompts[tone] ?? 'دوستانه' : 'دوستانه و صمیمی'}
${userName != null ? '- نام کاربر: $userName (از اسمش استفاده کن)' : ''}
- از ایموجی استفاده کن (ولی زیاد نه)
- جواب‌هات کوتاه و مفید باشه (حداکثر 150 کلمه)
- وقتی می‌خوای اذیت کنی تا کار انجام بشه، با مهربونی این کار رو کن

پیام کاربر:
"$message"

جواب رو بده:
''';
  }
  
  // Helper: تبدیل تاریخچه چت
  List<Content> _convertHistory(List<Map<String, String>> history) {
    return history.map((msg) {
      final role = msg['role'] == 'user' ? 'user' : 'model';
      return Content(role, [TextPart(msg['content'] ?? '')]);
    }).toList();
  }
}
