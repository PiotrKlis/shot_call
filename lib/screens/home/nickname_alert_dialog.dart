import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shot_call/shared_prefs.dart';
import 'package:shot_call/utils/screen_navigation_key.dart';
import 'package:shot_call/utils/text_field_validator.dart';

class NicknameAlertDialog extends StatelessWidget {
  const NicknameAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
              sharedPreferences.setString(
                SharedPrefs.keyNickname,
                controller.text,
              );
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
