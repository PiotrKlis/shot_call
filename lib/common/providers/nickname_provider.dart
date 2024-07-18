import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/data/shared_prefs.dart';

part 'nickname_provider.g.dart';

@riverpod
class Nickname extends _$Nickname {
  final _defaultValue = '';

  @override
  String build() {
    return sharedPreferences.getString(SharedPrefs.keyNickname) ??
        _defaultValue;
  }

  void update(String nickname) {
    sharedPreferences.setString(SharedPrefs.keyNickname, nickname);
    state = nickname;
  }
}
