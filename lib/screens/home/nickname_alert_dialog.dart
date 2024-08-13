import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shot_call/common/extensions/context_extensions.dart';
import 'package:shot_call/common/navigation/screen_navigation_key.dart';
import 'package:shot_call/common/providers/nickname_provider.dart';
import 'package:shot_call/styleguide/dimens.dart';
import 'package:shot_call/utils/text_field_validator.dart';

class NicknameAlertDialog extends ConsumerWidget {
  const NicknameAlertDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();
    return AlertDialog(
      title: Center(child: Text(context.strings.nickname_dialog_question)),
      content: Form(
        key: formKey,
        child: TextFormField(
          maxLength: Dimens.maxChars,
          decoration: InputDecoration(
            hintText: context.strings.nickname,
          ),
          controller: controller,
          focusNode: FocusNode(),
          autofocus: true,
          validator: (value) => TextFieldValidator.validate(
              value, context.strings.nickname_dialog_empty_error,),
        ),
      ),
      actions: [
        TextButton(
          child: Text(context.strings.nickname_dialog_confirm),
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
