import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/common/providers/nickname_provider.dart';
import 'package:shot_call/common/providers/party_name_provider.dart';
import 'package:shot_call/data/firestore_constants.dart';

part 'call_button_provider.g.dart';

@riverpod
class CallTheShotsButton extends _$CallTheShotsButton {
  @override
  Stream<CallButtonState> build() async* {
    final partyName = ref.watch(partyNameProvider);
    final nickname = ref.read(nicknameProvider);
    if (partyName.isNotEmpty) {
      yield* FirebaseFirestore.instance
          .collection(FirestoreConstants.parties)
          .doc(partyName)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          final alarmer = snapshot.data()?[FirestoreConstants.alarm] as String;
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
    } else {
      yield* Stream.value(CallButtonState(CallButtonStatus.empty, null));
    }
  }

  void callTheShots() {
    final partyName = ref.read(partyNameProvider);
    final nickname = ref.read(nicknameProvider);
    FirebaseFirestore.instance
        .collection(FirestoreConstants.parties)
        .doc(partyName)
        .update({FirestoreConstants.alarm: nickname});
  }

  void relieve() {
    final partyName = ref.read(partyNameProvider);
    FirebaseFirestore.instance
        .collection(FirestoreConstants.parties)
        .doc(partyName)
        .update({FirestoreConstants.alarm: FirestoreConstants.emptyValue});
  }
}

enum CallButtonStatus { idle, calling, relieve, empty }

class CallButtonState {
  CallButtonState(this.status, this.alarmer);

  final CallButtonStatus status;
  final String? alarmer;
}
