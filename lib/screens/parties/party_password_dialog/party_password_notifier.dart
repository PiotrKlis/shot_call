import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/screens/home/call_button_provider.dart';
import 'package:shot_call/screens/home/nickname_provider.dart';
import 'package:shot_call/screens/home/party_name_provider.dart';
import 'package:shot_call/shared_prefs.dart';
import 'package:shot_call/utils/should_show_error.dart';

part 'party_password_notifier.g.dart';

@riverpod
class PartyPasswordNotifier extends _$PartyPasswordNotifier {
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
      final isPasswordCorrect = party['password'] == password;
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
    await _addUserToParty(partyName);
    ref.read(partyNameProvider.notifier).update(partyName);
    state = const AsyncValue.data(null);
  }

  Future<void> _addUserToParty(String partyId) async {
    await FirebaseFirestore.instance.collection('parties').doc(partyId).update({
      'participants': FieldValue.arrayUnion(
        [ref.read(nicknameProvider)],
      ),
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
