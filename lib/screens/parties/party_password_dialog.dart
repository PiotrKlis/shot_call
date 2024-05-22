import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shot_call/party_participants_screen.dart';
import 'package:shot_call/shared_prefs.dart';

class PartyPasswordDialog extends StatelessWidget {
  const PartyPasswordDialog({required this.partyId, super.key});

  final String partyId;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return AlertDialog(
      title: const Center(child: Text('Jakie hasło wariacie')),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                hintText: 'Podaj hasło',
              ),
              controller: controller,
              focusNode: FocusNode(),
              autofocus: true,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              cursorColor: Colors.red,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () async {
            final party = await FirebaseFirestore.instance
                .collection('parties')
                .doc(partyId)
                .get();
            final data = party.data();
            if (data != null && data['password'] == controller.text) {
              FirebaseFirestore.instance
                  .collection('parties')
                  .doc(partyId)
                  .update({
                'alarm': [],
                'participants': FieldValue.arrayUnion(
                  [sharedPreferences.getString(SharedPrefs.keyNickname)],
                ),
              });
              sharedPreferences.setString('', partyId);
              await FirebaseMessaging.instance.subscribeToTopic(partyId);
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PartyParticipantsScreen(partyId: partyId),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
