import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shot_call/shared_prefs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  var nickname = sharedPreferences.get(SharedPrefs.nickname) ?? '';

  @override
  void initState() {
    super.initState();
    final shouldShowDialog =
        sharedPreferences.get(SharedPrefs.nickname) == null;
    if (shouldShowDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNicknameDialog(context);
      });
    }
  }

  Future<void> _showNicknameDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Center(child: Text('Jaka ksywa wariacie')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                EditableText(
                  controller: controller,
                  focusNode: FocusNode(),
                  autofocus: true,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  cursorColor: Colors.red,
                  backgroundCursorColor: Colors.red,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                child: const Text('Jedziemy'),
                onPressed: () async {
                  sharedPreferences.setString(
                      SharedPrefs.nickname, controller.text);
                  nickname = controller.text;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(nickname.toString())
                      .set({'alarm': false});
                  setState(() {});
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("@$nickname")),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
                'Wciśnij przycisk aby wezwać pomoc w razie zagrożenia bycia niedopitym.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24)),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(nickname.toString())
                    .set({'alarm': true});
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('🚨WÓD - CALL 🚨\n 🚨WEZWIJ POMOC 🚨',
                    textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(nickname.toString())
                      .set({'alarm': false});
                },
                child: const Text('😌 KRYZYS ZAŻEGNANY 😌')),
          ],
        ),
      ),
    );
  }
}
