import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/screens/home/nickname_provider.dart';
import 'package:shot_call/screens/home/party_name_provider.dart';

part 'call_button_provider.g.dart';

@riverpod
class CallTheShotsButton extends _$CallTheShotsButton {
  @override
  Stream<CallButtonState> build() async* {
    final partyName = ref.watch(partyNameProvider);
    final nickname = ref.read(nicknameProvider);
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

  void callTheShots() {
    final partyName = ref.read(partyNameProvider);
    final nickname = ref.read(nicknameProvider);
    FirebaseFirestore.instance
        .collection('parties')
        .doc(partyName)
        .update({'alarm': nickname});
  }
}

enum CallButtonState { idle, calling, relieve, empty }
