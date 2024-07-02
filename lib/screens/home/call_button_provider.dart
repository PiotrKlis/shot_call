import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/shared_prefs.dart';

part 'call_button_provider.g.dart';

@riverpod
class CallButton extends _$CallButton {
  @override
  Stream<CallButtonState> build() async* {
    final partyName = sharedPreferences.getString(SharedPrefs.keyPartyName);
    final nickname = sharedPreferences.getString(SharedPrefs.keyNickname);
    if (partyName != null) {
      yield* FirebaseFirestore.instance
          .collection('parties')
          .doc(partyName)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          final alarm = snapshot.data()?['alarm'] as String;
          if (alarm == nickname) {
            return CallButtonState.relieve;
          } else if (alarm.isNotEmpty) {
            return CallButtonState.calling;
          } else {
            return CallButtonState.idle;
          }
        } else {
          return CallButtonState.empty;
        }
      });
    }
  }

  void callTheShots() {
    final partyName = sharedPreferences.getString(SharedPrefs.keyPartyName);
    final nickname = sharedPreferences.getString(SharedPrefs.keyNickname);
    FirebaseFirestore.instance
        .collection('parties')
        .doc(partyName)
        .update({'alarm': nickname});
  }

  void reset() {

  }
}

enum CallButtonState { idle, calling, relieve, empty }
