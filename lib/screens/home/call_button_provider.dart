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
        final alarmer = snapshot.data()?['alarm'] as String;
        if (alarmer == nickname) {
          return CallButtonState(CallButtonStatus.relieve, alarmer);
        } else if (alarmer.isNotEmpty) {
          return CallButtonState(CallButtonStatus.calling, alarmer);
        } else {
          return CallButtonState(CallButtonStatus.idle, null);
        }
      } else {
        return CallButtonState(CallButtonStatus.empty, null);
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

  void relieve() {
    final partyName = ref.read(partyNameProvider);
    FirebaseFirestore.instance
        .collection('parties')
        .doc(partyName)
        .update({'alarm': ''});
  }
}

enum CallButtonStatus { idle, calling, relieve, empty }

class CallButtonState {
  CallButtonState(this.status, this.alarmer);

  final CallButtonStatus status;
  final String? alarmer;
}
