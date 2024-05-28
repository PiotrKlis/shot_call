import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shot_call/screens/parties/party_password_dialog/party_password_notifier.dart';

class PartyPasswordDialog extends ConsumerWidget {
  const PartyPasswordDialog({required this.partyId, super.key});

  final String partyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final partyPasswordNotifier =
        ref.read(partyPasswordStateNotifierProvider.notifier);

    ref.watch(partyPasswordStateNotifierProvider).when(
      data: (_) {
        //TODO: Add proper navigation
        // context.push('/parties/$partyId/participants');
      },
      error: (Object error, StackTrace stackTrace) {
        if (error is Exception && error.toString() == 'Invalid password') {
          ref.read(shouldShowErrorProvider.notifier).update();
        }
      },
      loading: () {
        //no-op
      },
    );
    return AlertDialog(
      title: const Center(child: Text('Jakie hasło wariacie')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Podaj hasło',
              ),
              controller: controller,
              focusNode: FocusNode(),
              autofocus: true,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              cursorColor: Colors.red,
            ),
            Visibility(
              visible: ref.watch(shouldShowErrorProvider),
              child: const Text('Invalid password'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () async {
            await partyPasswordNotifier.joinParty(
              partyId: partyId,
              password: controller.text,
              shouldShowError: ref.read(shouldShowErrorProvider.notifier),
            );
          },
        ),
      ],
    );
  }

// bool _shouldShowErrorText(WidgetRef ref) {
//   return false;
// ref.watch(partyPasswordStateNotifierProvider).when(
//   error: (error, _) {
//     return error is Exception && error.toString() == 'Invalid password';
//   },
//   data: (void data) {
//     return false;
//   },
//   loading: () {
//     return false;
//   },
// );
// }
}
