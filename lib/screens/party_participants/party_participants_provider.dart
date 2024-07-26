import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/common/providers/nickname_provider.dart';
import 'package:shot_call/common/providers/party_name_provider.dart';
import 'package:shot_call/data/firestore_constants.dart';

part 'party_participants_provider.g.dart';

@riverpod
class PartyParticipants extends _$PartyParticipants {
  @override
  Stream<List<String>> build() async* {
    final partyId = ref.read(partyNameProvider);
    yield* FirebaseFirestore.instance
        .collection(FirestoreConstants.parties)
        .doc(partyId)
        .snapshots()
        .map(
          (snapshot) =>
              (snapshot.data()![FirestoreConstants.participants] as List)
                  .map((item) => item as String)
                  .toList(),
        );
  }

  void removeParticipant() {
    final partyId = ref.read(partyNameProvider);
    final nickname = ref.read(nicknameProvider);
    FirebaseFirestore.instance
        .collection(FirestoreConstants.parties)
        .doc(partyId)
        .update({
      FirestoreConstants.participants: FieldValue.arrayRemove([nickname]),
    });
    ref.read(partyNameProvider.notifier).clear();
  }
}
