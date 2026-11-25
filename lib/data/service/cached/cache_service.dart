import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _bearerTokenKey = 'bearer_token';

  static Future<void> saveBearerToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_bearerTokenKey, token);
  }

  static Future<String?> getBearerToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_bearerTokenKey);
  }

  static Future<void> clearBearerToken() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_bearerTokenKey);
  }
}
