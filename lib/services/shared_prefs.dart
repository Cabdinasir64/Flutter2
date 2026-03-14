import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setName(String name) async {
    await _prefs?.setString('user_name', name);
  }

  static String getName() {
    return _prefs?.getString('user_name') ?? "Magac ma jiro";
  }
}
