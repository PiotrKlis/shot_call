import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shot_call/screens/parties/party_password_dialog/party_password_notifier.dart';
import 'package:shot_call/utils/logger.dart';
import 'package:shot_call/utils/navigation_constants.dart';
import 'package:shot_call/utils/screen_navigation_key.dart';
import 'package:shot_call/utils/should_show_error.dart';

class PartyPasswordDialog extends ConsumerWidget {
  const PartyPasswordDialog({required this.partyId, super.key});

  final String partyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _confirmationNavigationListener(ref, context);
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
            const SizedBox(height: 16),
            Visibility(
              visible: ref.watch(shouldShowErrorProvider),
              child: Text(
                'Błędne hasło!',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
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

  void _confirmationNavigationListener(WidgetRef ref, BuildContext context) {
    ref.listen(partyPasswordNotifierProvider, (previous, next) {
      if (next == const AsyncData<void>(null)) {
        context
          ..pop()
          ..pushNamed(
            ScreenNavigationKey.partyMembers,
            pathParameters: {NavigationConstants.partyId: partyId},
          );
      }
      if (next is AsyncError) {
        Logger.error(next.error, next.stackTrace);
      }
    });
  }
}
