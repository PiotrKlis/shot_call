import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shot_call/common/extensions/context_extensions.dart';
import 'package:shot_call/data/shared_prefs.dart';
import 'package:shot_call/screens/home/call_button_provider.dart';
import 'package:shot_call/screens/home/nickname_alert_dialog.dart';
import 'package:shot_call/styleguide/dimens.dart';
import 'package:shot_call/utils/logger.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _handleAskForNicknameDialog();
  }

  void _handleAskForNicknameDialog() {
    final shouldShowNicknameDialog =
        sharedPreferences.get(SharedPrefs.keyNickname) == null;
    if (shouldShowNicknameDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _showAskForNicknameDialog(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _HomeScreenContent(),
    );
  }

  Future<void> _showAskForNicknameDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const NicknameAlertDialog();
      },
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: _CallTheShotsSection(),
    );
  }
}

class _CallTheShotsSection extends ConsumerWidget {
  const _CallTheShotsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(Dimens.mMargin),
      child: ref.watch(callTheShotsButtonProvider).when(
        data: (data) {
          switch (data.status) {
            case CallButtonStatus.idle:
              return _ButtonView(
                context.strings.idle_button_title,
                context.strings.idle_button_subtitle,
                Colors.orange,
                'notification',
                () {
                  ref.read(callTheShotsButtonProvider.notifier).callTheShots();
                },
              );
            case CallButtonStatus.calling:
              return _ButtonView(
                context.strings.calling_button_title(data.alarmer ?? ''),
                context.strings.calling_button_subtitle,
                Colors.red,
                'alarm',
                null,
              );
            case CallButtonStatus.relieve:
              return _ButtonView(
                context.strings.relieve_button_title,
                context.strings.relieve_button_subtitle,
                Colors.green,
                'relieved',
                () {
                  ref.read(callTheShotsButtonProvider.notifier).relieve();
                },
              );
            case CallButtonStatus.empty:
              return Text(context.strings.party_signup_suggestion);
          }
        },
        error: (error, stackTrace) {
          Logger.error(error, stackTrace);
          // return Text(context.strings.party_signup_suggestion);
          return Text('Zapisz się na imprezę przegrywie');
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _ButtonView extends ConsumerWidget {
  const _ButtonView(
    this.topText,
    this.bottomText,
    this.color,
    this.imagePath,
    this.onPressed,
  );

  final String topText;
  final String bottomText;
  final Color color;
  final String imagePath;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textAlign: TextAlign.center,
          topText,
          style: const TextStyle(
            fontSize: Dimens.lFontSize,
          ),
        ),
        const SizedBox(
          height: Dimens.xmMargin,
        ),
        Text(
          textAlign: TextAlign.center,
          bottomText,
          style: const TextStyle(
            fontSize: Dimens.mFontSize,
          ),
        ),
        const SizedBox(height: Dimens.xmMargin),
        AvatarGlow(
          startDelay: const Duration(milliseconds: Dimens.buttonPulseDuration),
          child: GestureDetector(
            onTap: onPressed,
            child: Material(
              shape: const CircleBorder(),
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(Dimens.xlMargin),
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: Dimens.buttonIconRadius,
                  child: Image.asset('assets/images/$imagePath.png'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
