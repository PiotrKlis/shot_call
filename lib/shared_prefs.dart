import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

@injectable
class SharedPrefs {
  static const String keyNickname = 'key_nickname';

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}
