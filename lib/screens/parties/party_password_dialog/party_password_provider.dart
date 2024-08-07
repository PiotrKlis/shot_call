import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/common/extensions/string_extensions.dart';
import 'package:shot_call/common/providers/nickname_provider.dart';
import 'package:shot_call/common/providers/party_name_provider.dart';
import 'package:shot_call/common/providers/should_show_error_provider.dart';
import 'package:shot_call/data/firestore_constants.dart';

part 'party_password_provider.g.dart';

@riverpod
class PartyPassword extends _$PartyPassword {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.loading();
  }

  Future<void> joinParty({
    required String partyName,
    required String password,
  }) async {
    try {
      final party = await _getPartyData(partyName);
      final isPasswordCorrect = party[FirestoreConstants.password] == password;
      if (isPasswordCorrect) {
        await _handleCorrectPassword(partyName);
      } else {
        _handleIncorrectPassword();
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void _handleIncorrectPassword() {
    ref.read(shouldShowErrorProvider.notifier).show();
    state = AsyncValue.error('Invalid password', StackTrace.current);
  }

  Future<void> _handleCorrectPassword(String partyName) async {
    final isUserAlreadyInParty = partyName == ref.read(partyNameProvider);
    if (isUserAlreadyInParty) {
      state = const AsyncValue.data(null);
    } else {
      await _handleNewPartyParticipant(partyName);
    }
  }

  Future<void> _handleNewPartyParticipant(String partyName) async {
    await _addUserToParty(partyName);
    await _removeDataFromOtherParties();
    await FirebaseMessaging.instance
        .subscribeToTopic(partyName.removeAllWhiteSpaces());
    ref.read(partyNameProvider.notifier).update(partyName);
    state = const AsyncValue.data(null);
  }

  Future<void> _addUserToParty(String partyId) async {
    await FirebaseFirestore.instance
        .collection(FirestoreConstants.parties)
        .doc(partyId)
        .update({
      FirestoreConstants.participants: FieldValue.arrayUnion(
        [ref.read(nicknameProvider)],
      ),
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getPartyData(
    String partyId,
  ) async {
    final party = await FirebaseFirestore.instance
        .collection(FirestoreConstants.parties)
        .doc(partyId)
        .get();
    return party;
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
