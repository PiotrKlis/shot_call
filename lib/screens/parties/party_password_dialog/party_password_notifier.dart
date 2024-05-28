import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/shared_prefs.dart';
import 'package:shot_call/utils/should_show_error.dart';

part 'party_password_notifier.g.dart';

@riverpod
class PartyPasswordNotifier extends _$PartyPasswordNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.loading();
  }

  Future<AsyncValue<void>> joinParty({
    required String partyId,
    required String password,
  }) async {
    try {
      final party = await _getPartyData(partyId);
      final isPasswordCorrect = party['password'] == password;
      if (isPasswordCorrect) {
        return await _handleCorrectPassword(partyId);
      } else {
        return _handleIncorrectPassword();
      }
    } catch (error, stackTrace) {
      return AsyncValue.error(error, stackTrace);
    }
  }

  AsyncValue<void> _handleIncorrectPassword() {
    ref.read(shouldShowErrorProvider.notifier).show();
    return AsyncValue.error('Invalid password', StackTrace.current);
  }

  Future<AsyncValue<void>> _handleCorrectPassword(String partyId) async {
    await _addUserToParty(partyId);
    await FirebaseMessaging.instance.subscribeToTopic(partyId);
    return const AsyncValue.data(null);
  }

  Future<void> _addUserToParty(String partyId) async {
    await FirebaseFirestore.instance.collection('parties').doc(partyId).set({
      'participants': sharedPreferences.getString(SharedPrefs.keyNickname),
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getPartyData(
    String partyId,
  ) async {
    final party = await FirebaseFirestore.instance
        .collection('parties')
        .doc(partyId)
        .get();
    return party;
  }
}
