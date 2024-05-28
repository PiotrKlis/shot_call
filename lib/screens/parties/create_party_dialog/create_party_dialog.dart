import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shot_call/screens/parties/create_party_dialog/create_party_notifier.dart';
import 'package:shot_call/utils/text_field_validator.dart';

class CreatePartyDialog extends ConsumerWidget {
  const CreatePartyDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final partyNameController = TextEditingController();
    final passwordController = TextEditingController();
    final createPartyNotifier =
        ref.read(createPartyStateNotifierProvider.notifier);
    ref.listen(
      createPartyStateNotifierProvider,
      (previous, next) {
        if (next == const AsyncData<void>(null)) {
          context.pop();
        }
      },
    );
    return AlertDialog(
      title: const Center(child: Text('Jaka impreza wariacie')),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PartyNameTextField(partyNameController: partyNameController),
            _PartyPasswordTextField(passwordController: passwordController),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Stwórz imprezę'),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              await createPartyNotifier.createParty(
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

class _PartyPasswordTextField extends StatelessWidget {
  const _PartyPasswordTextField({
    required this.passwordController,
  });

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}

class _PartyNameTextField extends StatelessWidget {
  const _PartyNameTextField({
    required this.partyNameController,
  });

  final TextEditingController partyNameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}
