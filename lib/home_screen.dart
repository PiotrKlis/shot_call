import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shot_call/shared_prefs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  var nickname = sharedPreferences.get(SharedPrefs.nickname) ?? '@';

  @override
  void initState() {
    super.initState();
    final shouldShowDialog =
        sharedPreferences.get(SharedPrefs.nickname) == null;
    if (shouldShowDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _showNicknameDialog(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("@$nickname")),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('parties')
                .doc('dummy')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                      'Nie masz z kim pić? Wciśnij przycisk, na pewno ktoś się pojawi.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('🚨WÓD - CALL 🚨\n 🚨 WEZWIJ POMOC 🚨',
                          textAlign: TextAlign.center),
                    ),
                    onPressed: () async {
                      await _shotsCallPressed();
                    },
                  ),
                  const SizedBox(height: 60),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(nickname.toString())
                        .snapshots(),
                    builder: (context, snapshot) {
                      final isSnapshotEmpty =
                          snapshot.data?.data()?.isEmpty ?? true;
                      if (snapshot.data != null && !isSnapshotEmpty) {
                        return Visibility(
                          visible: snapshot.data?['alarm'],
                          child: ElevatedButton(
                            child: const Text(
                                '😌 ODWOŁAJ - KRYZYS ZOSTAŁ ZAŻEGNANY 😌'),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(nickname.toString())
                                  .update({'alarm': false});

                              FirebaseFirestore.instance
                                  .collection('parties')
                                  .doc(sharedPreferences
                                      .getString(SharedPrefs.partyName))
                                  .update({
                                'alarm': FieldValue.arrayRemove([nickname])
                              });
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _shotsCallPressed() async {
    final nickname = sharedPreferences.getString(SharedPrefs.nickname);
    await _addAlarmToUser(nickname);
    List<String> parties = await _getParties(nickname);
    for (final party in parties) {
      _addAlarmToParty(party, nickname);
    }
  }

  void _addAlarmToParty(String party, String? nickname) {
    FirebaseFirestore.instance
        .collection('parties')
        .doc(party)
        .update({'alarm': FieldValue.arrayUnion([nickname])});
  }

  Future<void> _addAlarmToUser(String? nickname) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(nickname)
        .update({'alarm': true});
  }

  Future<List<String>> _getParties(String? nickname) async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(nickname)
        .get();

    final parties = (user.data()?['parties'] as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    return parties;
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
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Ksywa',
                  ),
                  controller: controller,
                  focusNode: FocusNode(),
                  autofocus: true,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  cursorColor: Colors.red,
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
}
