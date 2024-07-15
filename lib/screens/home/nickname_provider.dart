import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/shared_prefs.dart';
part 'nickname_provider.g.dart';

@riverpod
class Nickname extends _$Nickname {
  @override
  String build() {
    return sharedPreferences.getString(SharedPrefs.keyNickname) ?? '';
  }

  void update(String nickname) {
    sharedPreferences.setString(SharedPrefs.keyNickname, nickname);
    state = nickname;
  }
}
