import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SessionManager {
  static SharedPreferences? _prefs; 
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveSession(String token, Map<String, dynamic> user) async {
    if (_prefs == null) {
      throw Exception('SessionManager no inicializado');
    }
    await _prefs!.setString(_keyToken, token);
    await _prefs!.setString(_keyUser, jsonEncode(user));
  }

  static Future<bool> isLoggedIn() async {
    return _prefs?.getString(_keyToken) != null;
  }

  static Future<void> clearSession() async {
    await _prefs?.remove(_keyToken);
    await _prefs?.remove(_keyUser);
  }
}
