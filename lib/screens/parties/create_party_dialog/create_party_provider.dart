import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/common/extensions/string_extensions.dart';
import 'package:shot_call/common/providers/nickname_provider.dart';
import 'package:shot_call/common/providers/party_name_provider.dart';
import 'package:shot_call/common/providers/should_show_error_provider.dart';
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
      final adjustedPartyName =
          partyName.removeSpecialChars().removeAllWhiteSpaces();
      await _removeDataFromOtherParties();
      await _createNewParty(adjustedPartyName, password);
      await FirebaseMessaging.instance.subscribeToTopic(adjustedPartyName);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _createNewParty(String partyName, String password) async {
    final party = await FirebaseFirestore.instance
        .collection(FirestoreConstants.parties)
        .doc(partyName)
        .get();

    if (party.exists) {
      ref.read(shouldShowErrorProvider.notifier).show();
      throw Exception('Party already exists');
    } else {
      await FirebaseFirestore.instance
          .collection(FirestoreConstants.parties)
          .doc(partyName)
          .set({
        FirestoreConstants.alarm: FirestoreConstants.emptyValue,
        FirestoreConstants.password: password,
        FirestoreConstants.participants: [ref.read(nicknameProvider)],
      });
      ref.read(partyNameProvider.notifier).update(partyName);
    }
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

    final isAlarmPresent = party.data()?.containsKey(FirestoreConstants.alarm);
    if (isAlarmPresent != null && isAlarmPresent) {
      final alarmer = party[FirestoreConstants.alarm] as String;
      final nickname = ref.read(nicknameProvider);
      if (alarmer == nickname) {
        await FirebaseFirestore.instance
            .collection(FirestoreConstants.parties)
            .doc(partyName)
            .update({FirestoreConstants.alarm: FirestoreConstants.emptyValue});
      }
    }
  }

  Future<void> _removeParticipant(String partyName) async {
    final party = await FirebaseFirestore.instance
        .collection(FirestoreConstants.parties)
        .doc(partyName)
        .get();

    final areParticipantsPresent =
        party.data()?.containsKey(FirestoreConstants.participants);
    if (areParticipantsPresent != null && areParticipantsPresent) {
      final participants = (party[FirestoreConstants.participants] as List)
          .map((item) => item.toString())
          .toList();
      final nickname = ref.read(nicknameProvider);
      if (participants.contains(nickname)) {
        await FirebaseFirestore.instance
            .collection(FirestoreConstants.parties)
            .doc(partyName)
            .update({
          FirestoreConstants.participants: FieldValue.arrayRemove([nickname]),
        });
      }
    }
  }
}
