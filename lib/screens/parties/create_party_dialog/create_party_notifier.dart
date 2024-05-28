import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/shared_prefs.dart';

part 'create_party_notifier.g.dart';

@riverpod
class CreatePartyStateNotifier extends _$CreatePartyStateNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.loading();
  }

  Future<void> createParty(String partyName, String password) async {
    try {
      await _removeNicknameFromOtherParties();
      await _createNewParty(partyName, password);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _createNewParty(String partyName, String password) async {
    await FirebaseFirestore.instance.collection('parties').doc(partyName).set({
      'alarm': <String>[],
      'password': password,
      'participants': sharedPreferences.getString(SharedPrefs.keyNickname),
    });
  }

  Future<void> _removeNicknameFromOtherParties() async {
    final otherParty = await _findParty();
    await _removeNicknameIfPresent(otherParty);
  }

  Future<void> _removeNicknameIfPresent(
    QuerySnapshot<Map<String, dynamic>> otherParty,
  ) async {
    for (final party in otherParty.docs) {
      await FirebaseFirestore.instance.collection('parties').doc(party.id).set({
        'participants': FieldValue.arrayRemove(
          [sharedPreferences.getString(SharedPrefs.keyNickname)],
        ),
      });
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _findParty() async {
    final otherParty = await FirebaseFirestore.instance
        .collection('parties')
        .where(
          'participants',
          arrayContains: sharedPreferences.getString(SharedPrefs.keyNickname),
        )
        .get();
    return otherParty;
  }
}
