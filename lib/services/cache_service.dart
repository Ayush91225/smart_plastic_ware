import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveLastUrl(String url) async {
    await _prefs?.setString('last_url', url);
  }

  static String? getLastUrl() => _prefs?.getString('last_url');

  static Future<void> saveFCMToken(String token) async {
    await _prefs?.setString('fcm_token', token);
  }

  static String? getFCMToken() => _prefs?.getString('fcm_token');
}
