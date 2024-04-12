import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

class SharedPrefs {
  static const String nickname = "nickname";

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}
