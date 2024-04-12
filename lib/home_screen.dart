import 'package:flutter/cupertino.dart';
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
    final shouldShowDialog = sharedPreferences.get(SharedPrefs.nickname) == null;
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
          actions: <Widget>[
            TextButton(
              child: const Text('Jedziemy z tematem'),
              onPressed: () {
                sharedPreferences.setString(SharedPrefs.nickname, controller.text);
                setState(() {
                  nickname = controller.text;
                });
                Navigator.of(context).pop();
              },
            ),
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
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              print('Button pressed');
            },
            child: const Text('Shot call'),
          ),
        ),
      ),
    );
  }
}
