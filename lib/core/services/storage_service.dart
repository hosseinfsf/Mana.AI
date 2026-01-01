import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../constants/app_constants.dart';

class StorageService {
  static StorageService? _instance;
  late SharedPreferences _prefs;
  late Box _hiveBox;
  
  StorageService._();
  
  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._();
      await _instance!._init();
    }
    return _instance!;
  }
  
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    await Hive.initFlutter();
    _hiveBox = await Hive.openBox('mana_box');
  }
  
  // ========== User Profile ==========
  
  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    await _prefs.setString(AppConstants.keyUserName, profile['name'] ?? '');
    await _prefs.setString(AppConstants.keyUserAge, profile['age'] ?? '');
    await _prefs.setString(AppConstants.keyUserActivity, profile['activity'] ?? '');
    await _prefs.setString(AppConstants.keyUserBirthMonth, profile['birthMonth'] ?? '');
    await _prefs.setString(AppConstants.keyUserCity, profile['city'] ?? '');
    await _prefs.setBool(AppConstants.keyFirstLaunch, false);
  }
  
  Map<String, String> getUserProfile() {
    return {
      'name': _prefs.getString(AppConstants.keyUserName) ?? '',
      'age': _prefs.getString(AppConstants.keyUserAge) ?? '',
      'activity': _prefs.getString(AppConstants.keyUserActivity) ?? '',
      'birthMonth': _prefs.getString(AppConstants.keyUserBirthMonth) ?? '',
      'city': _prefs.getString(AppConstants.keyUserCity) ?? '',
    };
  }
  
  bool isFirstLaunch() {
    return _prefs.getBool(AppConstants.keyFirstLaunch) ?? true;
  }
  
  // ========== Theme ==========
  
  Future<void> saveTheme(int themeIndex) async {
    await _prefs.setInt(AppConstants.keyCurrentTheme, themeIndex);
  }
  
  int getCurrentTheme() {
    return _prefs.getInt(AppConstants.keyCurrentTheme) ?? 0;
  }
  
  // ========== Floating Icon ==========
  
  Future<void> saveFloatingIconType(String type) async {
    await _prefs.setString(AppConstants.keyFloatingIconType, type);
  }
  
  String getFloatingIconType() {
    return _prefs.getString(AppConstants.keyFloatingIconType) ?? 'cat';
  }
  
  Future<void> saveFloatingIconSize(double size) async {
    await _prefs.setDouble(AppConstants.keyFloatingIconSize, size);
  }
  
  double getFloatingIconSize() {
    return _prefs.getDouble(AppConstants.keyFloatingIconSize) ?? 
           AppConstants.floatingIconDefaultSize;
  }
  
  Future<void> saveFloatingIconOpacity(double opacity) async {
    await _prefs.setDouble(AppConstants.keyFloatingIconOpacity, opacity);
  }
  
  double getFloatingIconOpacity() {
    return _prefs.getDouble(AppConstants.keyFloatingIconOpacity) ?? 1.0;
  }
  
  // ========== Chat History ==========
  
  Future<void> saveChatHistory(List<Map<String, String>> history) async {
    final jsonString = jsonEncode(history);
    await _hiveBox.put(AppConstants.keyChatHistory, jsonString);
  }
  
  List<Map<String, String>> getChatHistory() {
    final jsonString = _hiveBox.get(AppConstants.keyChatHistory);
    if (jsonString == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => Map<String, String>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }
  
  Future<void> clearChatHistory() async {
    await _hiveBox.delete(AppConstants.keyChatHistory);
  }
  
  // ========== Tasks ==========
  
  Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
    final jsonString = jsonEncode(tasks);
    await _hiveBox.put(AppConstants.keyTasks, jsonString);
  }
  
  List<Map<String, dynamic>> getTasks() {
    final jsonString = _hiveBox.get(AppConstants.keyTasks);
    if (jsonString == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }
  
  // ========== Shopping List ==========
  
  Future<void> saveShoppingList(List<Map<String, dynamic>> items) async {
    final jsonString = jsonEncode(items);
    await _hiveBox.put(AppConstants.keyShoppingList, jsonString);
  }
  
  List<Map<String, dynamic>> getShoppingList() {
    final jsonString = _hiveBox.get(AppConstants.keyShoppingList);
    if (jsonString == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }
  
  // ========== Notes ==========
  
  Future<void> saveNotes(List<Map<String, dynamic>> notes) async {
    final jsonString = jsonEncode(notes);
    await _hiveBox.put(AppConstants.keyNotes, jsonString);
  }
  
  List<Map<String, dynamic>> getNotes() {
    final jsonString = _hiveBox.get(AppConstants.keyNotes);
    if (jsonString == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }
  
  // ========== Last Hafez ==========
  
  Future<void> saveLastHafez(Map<String, String> hafez) async {
    final jsonString = jsonEncode(hafez);
    await _hiveBox.put(AppConstants.keyLastHafez, jsonString);
  }
  
  Map<String, String>? getLastHafez() {
    final jsonString = _hiveBox.get(AppConstants.keyLastHafez);
    if (jsonString == null) return null;
    
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      return null;
    }
  }
  
  // ========== Morning Mana Settings ==========
  
  Future<void> saveMorningManaSettings(List<Map<String, dynamic>> settings) async {
    final jsonString = jsonEncode(settings);
    await _prefs.setString('morning_mana_settings', jsonString);
  }
  
  List<Map<String, dynamic>> getMorningManaSettings() {
    final jsonString = _prefs.getString('morning_mana_settings');
    if (jsonString == null) return List.from(AppConstants.morningManaSections);
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      return List.from(AppConstants.morningManaSections);
    }
  }
  
  // ========== Clipboard History ==========
  
  Future<void> addToClipboardHistory(String text) async {
    final history = getClipboardHistory();
    history.insert(0, {
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    // Keep only last 50
    if (history.length > 50) {
      history.removeRange(50, history.length);
    }
    
    final jsonString = jsonEncode(history);
    await _hiveBox.put('clipboard_history', jsonString);
  }
  
  List<Map<String, dynamic>> getClipboardHistory() {
    final jsonString = _hiveBox.get('clipboard_history');
    if (jsonString == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }
  
  Future<void> clearClipboardHistory() async {
    await _hiveBox.delete('clipboard_history');
  }
  
  // ========== Generic Methods ==========
  
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }
  
  String? getString(String key) {
    return _prefs.getString(key);
  }
  
  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }
  
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }
  
  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }
  
  int? getInt(String key) {
    return _prefs.getInt(key);
  }
  
  Future<void> saveDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }
  
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }
  
  Future<void> remove(String key) async {
    await _prefs.remove(key);
    await _hiveBox.delete(key);
  }
  
  Future<void> clearAll() async {
    await _prefs.clear();
    await _hiveBox.clear();
  }
}