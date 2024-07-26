import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/data/shared_prefs.dart';

part 'party_name_provider.g.dart';

@riverpod
class PartyName extends _$PartyName {
  final _defaultValue = '';

  @override
  String build() {
    return sharedPreferences.getString(SharedPrefs.keyPartyName) ??
        _defaultValue;
  }

  void update(String partyName) {
    sharedPreferences.setString(SharedPrefs.keyPartyName, partyName);
    state = partyName;
  }

  void clear() {
    sharedPreferences.remove(SharedPrefs.keyPartyName);
    state = _defaultValue;
  }
}
