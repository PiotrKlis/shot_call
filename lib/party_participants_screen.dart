import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PartyParticipantsScreen extends StatelessWidget {
  const PartyParticipantsScreen({required String partyId, super.key})
      : _partyId = partyId;

  final String _partyId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imprezowicze'),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(
            24,
          ),
          child: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.only(top: 24),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('parties')
                      .doc(_partyId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final participants =
                          (snapshot.data?['participants'] as List<dynamic>)
                              .map((e) => e.toString())
                              .toList();
                      return ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              const Divider(),
                          itemCount: participants.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                title: Text(participants[index]),
                                onTap: () {
                                  // _showPartyPasswordDialog(context, id);
                                });
                          });
                    } else {
                      return Container();
                    }
                  },
                )),
          ),
        ),
      ),
    );
  }
}
