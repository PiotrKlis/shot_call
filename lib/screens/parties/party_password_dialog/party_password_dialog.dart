import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shot_call/common/extensions/context_extensions.dart';
import 'package:shot_call/common/navigation/navigation_constants.dart';
import 'package:shot_call/common/navigation/screen_navigation_key.dart';
import 'package:shot_call/common/providers/should_show_error_provider.dart';
import 'package:shot_call/screens/parties/party_password_dialog/party_password_provider.dart';
import 'package:shot_call/utils/logger.dart';

class PartyPasswordDialog extends ConsumerWidget {
  const PartyPasswordDialog({required this.partyName, super.key});

  final String partyName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _confirmationNavigationListener(ref, context);
    final controller = TextEditingController();
    return AlertDialog(
      title: Center(child: Text(context.strings.password_dialog_question)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: context.strings.password,
              ),
              controller: controller,
              focusNode: FocusNode(),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: ref.watch(shouldShowErrorProvider),
              child: Text(
                context.strings.wrong_password,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(context.strings.ok),
          onPressed: () {
            ref.read(partyPasswordProvider.notifier).joinParty(
                  partyName: partyName,
                  password: controller.text,
                );
          },
        ),
      ],
    );
  }

  void _confirmationNavigationListener(WidgetRef ref, BuildContext context) {
    ref.listen(partyPasswordProvider, (previous, next) {
      if (next == const AsyncData<void>(null)) {
        context
          ..pop()
          ..pushNamed(
            ScreenNavigationKey.partyMembers,
            pathParameters: {NavigationConstants.partyId: partyName},
          );
      }
      if (next is AsyncError) {
        Logger.error(next.error, next.stackTrace);
      }
    });
  }
}
