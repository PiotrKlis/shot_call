import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/shared_prefs.dart';

part 'party_name_provider.g.dart';

@riverpod
class PartyName extends _$PartyName {
  @override
  String build() {
    return sharedPreferences.getString(SharedPrefs.keyPartyName) ?? '';
  }

  void update(String partyName) {
    sharedPreferences.setString(SharedPrefs.keyPartyName, partyName);
    state = partyName;
  }
}
