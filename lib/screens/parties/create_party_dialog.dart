import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shot_call/screens/parties/parties_creation_notifier.dart';
import 'package:shot_call/utils/text_field_validator.dart';

class CreatePartyDialog extends ConsumerWidget {
  const CreatePartyDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final partyNameController = TextEditingController();
    final passwordController = TextEditingController();
    final partyCreationNotifier = ref.read(partyCreationProvider.notifier);

    ref.watch(partyCreationProvider).when(
          data: (_) {
            context.pop();
          },
          loading: () {

          },
          error: (error, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $error')),
            );
          },
        );
    return AlertDialog(
      title: const Center(child: Text('Jaka impreza wariacie')),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Nazwa imprezy',
              ),
              controller: partyNameController,
              focusNode: FocusNode(),
              autofocus: true,
              validator: (value) => TextFieldValidator.validateIsEmpty(
                value,
                'Nazwa imprezy nie może być pusta :|',
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Hasło',
              ),
              controller: passwordController,
              focusNode: FocusNode(),
              autofocus: true,
              validator: (value) => TextFieldValidator.validateIsEmpty(
                value,
                'Hasło nie może być puste :|',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Stwórz imprezę'),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              await partyCreationNotifier.createParty(
                partyNameController.text,
                passwordController.text,
              );
            }
          },
        ),
      ],
    );
  }
}
