import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shot_call/common/extensions/context_extensions.dart';
import 'package:shot_call/screens/parties/create_party_dialog/create_party_provider.dart';
import 'package:shot_call/utils/text_field_validator.dart';

class CreatePartyDialog extends ConsumerWidget {
  const CreatePartyDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final partyNameController = TextEditingController();
    final passwordController = TextEditingController();
    ref.listen(
      createPartyProvider,
      (previous, next) {
        if (next == const AsyncData<void>(null)) {
          context.pop();
        }
      },
    );
    return AlertDialog(
      title:
          Center(child: Text(context.strings.party_creation_dialog_question)),
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
          child: Text(context.strings.party_creation_dialog_confirm),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              await ref.read(createPartyProvider.notifier).createParty(
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
      decoration: InputDecoration(
        hintText: context.strings.password,
      ),
      controller: passwordController,
      focusNode: FocusNode(),
      autofocus: true,
      validator: (value) => TextFieldValidator.validateIsEmpty(
        value,
        context.strings.empty_password_error,
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
      decoration: InputDecoration(
        hintText: context.strings.party_name,
      ),
      controller: partyNameController,
      focusNode: FocusNode(),
      autofocus: true,
      validator: (value) => TextFieldValidator.validateIsEmpty(
        value,
        context.strings.empty_party_name,
      ),
    );
  }
}
