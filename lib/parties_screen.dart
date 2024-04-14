import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PartiesScreen extends StatelessWidget {
  const PartiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(
              24,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text('Imprezy', style: TextStyle(fontSize: 30)),
                  Container(
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
                              separatorBuilder: (context, index) => const Divider(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(snapshot.data!.docs[index].id),
                                  onTap: () {
                                    //TODO: Implement me
                                    _showPartyPasswordDialog(context);
                                  }
                                );
                              }
                            );
                          } else {
                            return Container();
                          }
                        },
                      )),
                ],
              ),
            ),
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
                      .set({'password': passwordController.text});
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  Future<void> _showPartyPasswordDialog(BuildContext context) async {
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

                }),
          ],
        );
      },
    );
  }
}
