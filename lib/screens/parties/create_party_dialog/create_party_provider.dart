import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/common/providers/nickname_provider.dart';
import 'package:shot_call/common/providers/party_name_provider.dart';
import 'package:shot_call/data/firestore_constants.dart';

part 'create_party_provider.g.dart';

@riverpod
class CreateParty extends _$CreateParty {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.loading();
  }

  Future<void> createParty(String partyName, String password) async {
    try {
      await _removeDataFromOtherParties();
      await _createNewParty(partyName, password);
      await FirebaseMessaging.instance.subscribeToTopic(partyName);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _createNewParty(String partyName, String password) async {
    await FirebaseFirestore.instance
        .collection(FirestoreConstants.parties)
        .doc(partyName)
        .set({
      FirestoreConstants.alarm: FirestoreConstants.emptyValue,
      FirestoreConstants.password: password,
      FirestoreConstants.participants: FieldValue.arrayUnion(
        [ref.read(nicknameProvider)],
      ),
    });
    ref.read(partyNameProvider.notifier).update(partyName);
  }

  Future<void> _removeDataFromOtherParties() async {
    await () async {
      final partyName = ref.read(partyNameProvider);
      if (partyName.isNotEmpty) {
        await _removeAlarmer(partyName);
        await _removeParticipant(partyName);
      }
    }();
  }

  Future<void> _removeAlarmer(String partyName) async {
    final party = await FirebaseFirestore.instance
        .collection(FirestoreConstants.parties)
        .doc(partyName)
        .get();

    final nickname = ref.read(nicknameProvider);
    final alarmer = party[FirestoreConstants.alarm] as String;

    if (alarmer == nickname) {
      await FirebaseFirestore.instance
          .collection(FirestoreConstants.parties)
          .doc(partyName)
          .update({FirestoreConstants.alarm: FirestoreConstants.emptyValue});
    }
  }

  Future<void> _removeParticipant(String partyName) async {
    await FirebaseFirestore.instance
        .collection(FirestoreConstants.parties)
        .doc(partyName)
        .update({
      FirestoreConstants.participants: FieldValue.arrayRemove(
        [ref.read(nicknameProvider)],
      ),
    });
  }
}
