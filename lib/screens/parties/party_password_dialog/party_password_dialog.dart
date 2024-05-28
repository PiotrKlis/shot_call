import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shot_call/screens/parties/party_password_dialog/party_password_notifier.dart';
import 'package:shot_call/utils/should_show_error.dart';

class PartyPasswordDialog extends ConsumerWidget {
  const PartyPasswordDialog({required this.partyId, super.key});

  final String partyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(partyPasswordNotifierProvider, (previous, next) {
      if (next is AsyncData) {
        Navigator.of(context).pop();
      }
    });
    final controller = TextEditingController();
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
            ),
            Visibility(
              //TODO: I not rebuild myself :(
              visible: ref.watch(shouldShowErrorProvider),
              child: const Text('Invalid password'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            ref.read(partyPasswordNotifierProvider.notifier).joinParty(
                  partyId: partyId,
                  password: controller.text,
                );
          },
        ),
      ],
    );
  }
}
