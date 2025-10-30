// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ThemeProvider with ChangeNotifier {
  bool _isCareVersion = false;
  
  bool get isCareVersion => _isCareVersion;
  
  ThemeData get currentTheme {
    return _isCareVersion ? AppThemes.careTheme : AppThemes.normalTheme;
  }
  
  void toggleTheme() {
    _isCareVersion = !_isCareVersion;
    notifyListeners();
  }
  
  void setCareVersion(bool isCare) {
    _isCareVersion = isCare;
    notifyListeners();
  }
}