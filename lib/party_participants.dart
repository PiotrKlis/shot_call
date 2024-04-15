import 'package:flutter/material.dart';

class PartyParticipantsScreen extends StatelessWidget {
  const PartyParticipantsScreen({super.key, required String partyId})
      : _partyId = partyId;

  final String _partyId;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Party participants screen id: $_partyId"));
  }
}
