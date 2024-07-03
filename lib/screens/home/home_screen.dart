import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shot_call/screens/home/call_button_provider.dart';
import 'package:shot_call/screens/home/nickname_alert_dialog.dart';
import 'package:shot_call/screens/home/nickname_provider.dart';
import 'package:shot_call/screens/home/party_name_provider.dart';
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
        margin: const EdgeInsets.all(24),
        child: Container(
          margin: const EdgeInsets.only(top: 24),
          child: const _CallTheShotsButton(),
        ),
      ),
    );
  }
}

class _PartyName extends ConsumerWidget {
  const _PartyName();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partyName = ref.watch(partyNameProvider);
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        partyName.isNotEmpty
            ? 'Impreza: $partyName'
            : 'Nie jesteś na żadnej imprezie przegrywie',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}

class _CallTheShotsButton extends ConsumerWidget {
  const _CallTheShotsButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(callTheShotsButtonProvider).when(
      data: (data) {
        switch (data) {
          case CallButtonState.idle:
            return const _IdleButton();
          case CallButtonState.calling:
            return const _CallingButton();
          case CallButtonState.relieve:
            return const _RelieveButton();
          case CallButtonState.empty:
            return Container();
        }
      },
      error: (error, stackTrace) {
        Logger.error(error, stackTrace);
        return const Text('Something went wrong :/');
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _RelieveButton extends StatelessWidget {
  const _RelieveButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 24),
          '😌 ODWOŁAJ ALARM \n KRYZYS ZOSTAŁ ZAŻEGNANY 😌',
        ),
      ),
      onPressed: () {
        //
      },
    );
  }
}

class _CallingButton extends StatelessWidget {
  const _CallingButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: const Text(
        textAlign: TextAlign.center,
        '🚨 🚨 🚨 🚨 🚨 🚨 \n\n Użytkownik "dodaj nickname" potrzebuje pomocy! Rzuć wszystko i jak naszybciej idź się z nim napić zanim wyschnie! \n\n 🚨 🚨 🚨 🚨 🚨 🚨',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _IdleButton extends ConsumerWidget {
  const _IdleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Text(
          'Zaschło Ci w gardle i nie masz z kim się napić? Wciśnij przycisk żeby wezwać posiłki!',
          style: TextStyle(
            fontSize: 36,
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              '🚨 WÓD - CALL 🚨\n🚨 WEZWIJ POMOC 🚨',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          onPressed: () {
            ref.read(callTheShotsButtonProvider.notifier).callTheShots();
          },
        ),
      ],
    );
  }
}
