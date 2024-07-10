import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/screens/home/nickname_provider.dart';
import 'package:shot_call/screens/home/party_name_provider.dart';
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
    await _removeDataFromOtherParties();
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
        .collection('parties')
        .doc(partyName)
        .get();

    final nickname = ref.read(nicknameProvider);
    final alarmer = party['alarm'] as String;

    if (alarmer == nickname) {
      await FirebaseFirestore.instance
          .collection('parties')
          .doc(partyName)
          .update({'alarm': ''});
    }
  }

  Future<void> _removeParticipant(String partyName) async {
    await FirebaseFirestore.instance
        .collection('parties')
        .doc(partyName)
        .update({
      'participants': FieldValue.arrayRemove(
        [ref.read(nicknameProvider)],
      ),
    });
  }
}
