import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/screens/home/nickname_provider.dart';
import 'package:shot_call/screens/home/party_name_provider.dart';

part 'create_party_notifier.g.dart';

@riverpod
class CreatePartyStateNotifier extends _$CreatePartyStateNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.loading();
  }

  Future<void> createParty(String partyName, String password) async {
    try {
      await _removeDataFromOtherParties();
      await _createNewParty(partyName, password);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _createNewParty(String partyName, String password) async {
    await FirebaseFirestore.instance.collection('parties').doc(partyName).set({
      'alarm': '',
      'password': password,
      'participants': FieldValue.arrayUnion(
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
