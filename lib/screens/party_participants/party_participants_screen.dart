import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shot_call/common/extensions/context_extensions.dart';
import 'package:shot_call/screens/party_participants/party_participants_provider.dart';
import 'package:shot_call/styleguide/dimens.dart';

class PartyParticipantsScreen extends ConsumerWidget {
  const PartyParticipantsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.party_members),
      ),
      body: Container(
        margin: const EdgeInsets.all(
          Dimens.xmMargin,
        ),
        child: const _ParticipantsList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(partyParticipantsProvider.notifier).removeParticipant();
          context.pop();
        },
        child: const Icon(Icons.door_back_door),
      ),
    );
  }
}

class _ParticipantsList extends ConsumerWidget {
  const _ParticipantsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: Dimens.xmMargin),
        child: ref.watch(partyParticipantsProvider).when(
              data: (participants) {
                return ListView.separated(
                  primary: false,
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
