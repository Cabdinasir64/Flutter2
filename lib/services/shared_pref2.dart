import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setUserData(String name, int age) async {
    await _prefs?.setString('user_name', name);
    await _prefs?.setInt('user_age', age);
  }

  static String getName() => _prefs?.getString('user_name') ?? "Magac ma jiro";
  static int getAge() => _prefs?.getInt('user_age') ?? 0;

  static Future<void> clearUser() async {
    await _prefs?.remove('user_name');
    await _prefs?.remove('user_age');
  }
}