import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shot_call/common/extensions/context_extensions.dart';
import 'package:shot_call/screens/party_participants/party_participants_provider.dart';

class PartyParticipantsScreen extends StatelessWidget {
  const PartyParticipantsScreen({required String partyId, super.key})
      : _partyId = partyId;

  final String _partyId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.party_members),
      ),
      body: Container(
        margin: const EdgeInsets.all(
          24,
        ),
        child: _ParticipantsList(_partyId),
      ),
    );
  }
}

class _ParticipantsList extends ConsumerWidget {
  const _ParticipantsList(this._partyId);

  final String _partyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 24),
        child: ref.watch(partyParticipantsStreamProvider(_partyId)).when(
              data: (participants) {
                return ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(participants[index]),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) {
                return Center(
                  child: Text('Error: $error'),
                );
              },
            ),
      ),
    );
  }
}
