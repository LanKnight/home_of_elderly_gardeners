// lib/utils/theme.dart
import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData get normalTheme {
    return ThemeData(
      primarySwatch: Colors.green,
      fontFamily: 'NotoSansSC',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
      ),
    );
  }
  
  static ThemeData get careTheme {
    return ThemeData(
      primarySwatch: Colors.green,
      fontFamily: 'NotoSansSC',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 20),
        bodyMedium: TextStyle(fontSize: 18),
        titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      iconTheme: const IconThemeData(size: 28),
    );
  }
}