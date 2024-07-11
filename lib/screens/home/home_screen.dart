import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shot_call/screens/home/call_button_provider.dart';
import 'package:shot_call/screens/home/nickname_alert_dialog.dart';
import 'package:shot_call/shared_prefs.dart';
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
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: const _CallTheShotsSection(),
      ),
    );
  }
}

class _CallTheShotsSection extends ConsumerWidget {
  const _CallTheShotsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(callTheShotsButtonProvider).when(
      data: (data) {
        switch (data.status) {
          case CallButtonStatus.idle:
            return _ButtonView(
              'Zaschło Ci w gardle i nie masz się z kim napić?',
              'Wciśnij przycisk żeby wezwać posiłki!',
              Colors.orange,
              'notification',
              () {
                ref.read(callTheShotsButtonProvider.notifier).callTheShots();
              },
            );
          case CallButtonStatus.calling:
            return _ButtonView(
              '${data.alarmer} potrzebuje pomocy!',
              'Natychmiast rzuć wszytko co robisz i idź się z nim napić!',
              Colors.red,
              'alarm',
              null,
            );
          case CallButtonStatus.relieve:
            return _ButtonView(
              'Nie lękaj się! Pomoc jest w drodze!',
              'Kliknij żeby odwołać alarm.',
              Colors.green,
              'relieved',
              () {
                ref.read(callTheShotsButtonProvider.notifier).relieve();
              },
            );
          case CallButtonStatus.empty:
            return const Text('Zapisz się na imprezę przegrywie');
        }
      },
      error: (error, stackTrace) {
        Logger.error(error, stackTrace);
        return const Text('Zapisz się na imprezę przegrywie');
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
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
            fontSize: 36,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          textAlign: TextAlign.center,
          bottomText,
          style: const TextStyle(
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 36),
        AvatarGlow(
          startDelay: const Duration(milliseconds: 1000),
          child: GestureDetector(
            onTap: onPressed,
            child: Material(
              shape: const CircleBorder(),
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(64),
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: 120,
                  child: Image.asset('assets/images/$imagePath.png'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    ;
  }
}
