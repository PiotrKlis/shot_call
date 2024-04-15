import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shot_call/party_participants_screen.dart';
import 'package:shot_call/shared_prefs.dart';

class PartiesScreen extends StatelessWidget {
  const PartiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Imprezki'),),
        body: Container(
          margin: const EdgeInsets.all(
            24,
          ),
          child: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.only(top: 24),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('parties')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              const Divider(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final id = snapshot.data!.docs[index].id;
                            return ListTile(
                                title: Text(id),
                                onTap: () {
                                  _showPartyPasswordDialog(context, id);
                                });
                          });
                    } else {
                      return Container();
                    }
                  },
                )),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showCreatePartyDialog(context);
          },
          child: const Icon(Icons.add),
        ));
  }

  Future<void> _showCreatePartyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final TextEditingController partyNameController =
            TextEditingController();
        final TextEditingController passwordController =
            TextEditingController();
        return AlertDialog(
          title: const Center(child: Text('Jaka impreza wariacie')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Nazwa imprezy',
                  ),
                  controller: partyNameController,
                  focusNode: FocusNode(),
                  autofocus: true,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  cursorColor: Colors.red,
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Hasło',
                  ),
                  controller: passwordController,
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
                child: const Text('Stwórz imprezę'),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('parties')
                      .doc(partyNameController.text)
                      .set({
                    'password': passwordController.text,
                    'participants':
                        sharedPreferences.getString(SharedPrefs.nickname)
                  });
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  Future<void> _showPartyPasswordDialog(BuildContext context, String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController();
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
                child: const Text('OK'),
                onPressed: () async {
                  final party = await FirebaseFirestore.instance
                      .collection('parties')
                      .doc(id)
                      .get();
                  final data = party.data();
                  if (data != null && data['password'] == controller.text) {
                    FirebaseFirestore.instance
                        .collection('parties')
                        .doc(id)
                        .update({
                      'participants': FieldValue.arrayUnion(
                          [sharedPreferences.getString(SharedPrefs.nickname)])
                    });
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PartyParticipantsScreen(partyId: id)),
                    );
                  }
                }),
          ],
        );
      },
    );
  }
}
