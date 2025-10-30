import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> saveJson(String key, Map<String, dynamic> json) async {
    await saveString(key, jsonEncode(json));
  }

  static Future<Map<String, dynamic>?> getJson(String key) async {
    final s = await getString(key);
    if (s == null) return null;
    return jsonDecode(s) as Map<String, dynamic>;
  }
}
