import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Clase para manejar sesión del usuario usando SharedPreferences.
class SessionManager {
  static SharedPreferences? _prefs; 

  // Claves para almacenar token y datos de usuario en SharedPreferences
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';

  /// Inicializa la instancia de SharedPreferences.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Guarda el token y los datos del usuario en SharedPreferences.
  ///
  /// [token] es el token de autenticación.
  /// [user] es un mapa con los datos del usuario, que se guarda como JSON.
  static Future<void> saveSession(String token, Map<String, dynamic> user) async {
    if (_prefs == null) {
      throw Exception('SessionManager no inicializado');
    }
    await _prefs!.setString(_keyToken, token);
    await _prefs!.setString(_keyUser, jsonEncode(user));
  }

  /// Verifica si el usuario está logueado (existe token guardado).
  static Future<bool> isLoggedIn() async {
    return _prefs?.getString(_keyToken) != null;
  }

  /// Borra la sesión actual (token y datos del usuario).
  static Future<void> clearSession() async {
    await _prefs?.remove(_keyToken);
    await _prefs?.remove(_keyUser);
  }
  
  /// Obtiene el ID del usuario almacenado en la sesión.
  ///
  /// Retorna null si no hay datos o si no está inicializado.
  static Future<int?> getUserId() async {
    if (_prefs == null) {
      throw Exception('SessionManager no inicializado');
    }
    
    final userDataString = _prefs!.getString(_keyUser);
    if (userDataString == null) return null;
    
    final Map<String, dynamic> userData = jsonDecode(userDataString);
    return userData['id'];
  }

  /// Obtiene el token de autenticación guardado.
  static Future<String?> getToken() async {
    if (_prefs == null) {
      throw Exception('SessionManager no inicializado');
    }
    return _prefs!.getString(_keyToken);
  }
}
