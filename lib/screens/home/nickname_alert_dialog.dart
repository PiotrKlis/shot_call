import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shot_call/screens/home/nickname_provider.dart';
import 'package:shot_call/shared_prefs.dart';
import 'package:shot_call/utils/screen_navigation_key.dart';
import 'package:shot_call/utils/text_field_validator.dart';

class NicknameAlertDialog extends ConsumerWidget {
  const NicknameAlertDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();
    return AlertDialog(
      title: const Center(child: Text('Jaka ksywa wariacie')),
      content: Form(
        key: formKey,
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: 'Ksywa',
          ),
          controller: controller,
          focusNode: FocusNode(),
          autofocus: true,
          validator: (value) => TextFieldValidator.validateIsEmpty(
              value, 'Ksywa nie może być pusta :|'),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Jedziemy'),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              ref.read(nicknameProvider.notifier).update(controller.text);
              context
                ..pop()
                ..goNamed(ScreenNavigationKey.parties);
            }
          },
        ),
      ],
    );
  }
}
