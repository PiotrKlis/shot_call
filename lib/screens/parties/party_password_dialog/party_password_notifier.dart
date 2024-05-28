import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/shared_prefs.dart';

part 'party_password_notifier.g.dart';

@riverpod
class ShouldShowError extends _$ShouldShowError {
  @override
  bool build() {
    return false;
  }

  void update() => !state;
}

@riverpod
class PartyPasswordStateNotifier extends _$PartyPasswordStateNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncLoading();
  }

  Future<void> joinParty({
    required String partyId,
    required String password,
    required ShouldShowError shouldShowError,
  }) async {
    ref.read(shouldShowErrorProvider.notifier).update();
    try {
      final party = await _getPartyData(partyId);
      final isPasswordCorrect = party['password'] == password;
      if (isPasswordCorrect) {
        await _addUserToParty(partyId);
        await FirebaseMessaging.instance.subscribeToTopic(partyId);
        state = const AsyncValue.data(null);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      shouldShowError.update();
    }
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
