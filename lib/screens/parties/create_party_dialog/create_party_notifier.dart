import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/screens/home/call_button_provider.dart';
import 'package:shot_call/screens/home/nickname_provider.dart';
import 'package:shot_call/screens/home/party_name_provider.dart';
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
      'alarm': '',
      'password': password,
      'participants': FieldValue.arrayUnion(
        [ref.read(nicknameProvider)],
      ),
    });
    ref.read(partyNameProvider.notifier).update(partyName);
  }

  Future<void> _removeNicknameFromOtherParties() async {
    await () async {
      final partyName = ref.read(partyNameProvider);
      if (partyName.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('parties')
            .doc(partyName)
            .update({
          'participants': FieldValue.arrayRemove(
            [ref.read(nicknameProvider)],
          ),
        });
      }
    }();
  }
}
