import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_mode.dart';
import '../utils/tourist_translations.dart';

class AppProvider extends ChangeNotifier {
  AppMode _currentMode = AppMode.normal;
  String _language = "中文";
  bool _isDarkMode = false;
  TouristLang _touristLang = TouristLang.zh;

  AppMode get currentMode => _currentMode;
  bool get isSimpleMode => _currentMode == AppMode.simple;
  String get language => _language;
  bool get isDarkMode => _isDarkMode;
  TouristLang get touristLang => _touristLang;

  AppProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt('appMode') ?? 0;
    _currentMode = AppMode.values[modeIndex];
    
    // For migration/backward compatibility if needed
    if (prefs.containsKey('isSimpleMode') && prefs.getBool('isSimpleMode') == true) {
      _currentMode = AppMode.simple;
    }

    _language = prefs.getString('language') ?? "中文";
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    final touristLangCode = prefs.getString('touristLang') ?? TouristLang.en.code;
    _touristLang = TouristLangExt.fromCode(touristLangCode);
    notifyListeners();
  }

  Future<void> setAppMode(AppMode mode) async {
    _currentMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('appMode', mode.index);
    // Also update deprecated isSimpleMode for safety during transition
    await prefs.setBool('isSimpleMode', mode == AppMode.simple);
    notifyListeners();
  }

  // Deprecated: use setAppMode instead
  Future<void> toggleSimpleMode(bool value) async {
    await setAppMode(value ? AppMode.simple : AppMode.normal);
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    notifyListeners();
  }
  
  // Basic localization helper
  String getText(String enText, String zhText) {
    return _language == "中文" ? zhText : enText;
  }

  Future<void> setTouristLang(TouristLang lang) async {
    _touristLang = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('touristLang', lang.code);
    notifyListeners();
  }
}
