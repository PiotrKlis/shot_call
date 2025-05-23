import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shot_call/common/extensions/context_extensions.dart';
import 'package:shot_call/screens/parties/create_party_dialog/create_party_dialog.dart';
import 'package:shot_call/screens/parties/parties_provider.dart';
import 'package:shot_call/screens/parties/party_password_dialog/party_password_dialog.dart';
import 'package:shot_call/styleguide/dimens.dart';

class PartiesScreen extends ConsumerWidget {
  const PartiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: const _PartiesScreenContent(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showCreatePartyDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _showCreatePartyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const CreatePartyDialog();
      },
    );
  }
}

class _PartiesScreenContent extends StatelessWidget {
  const _PartiesScreenContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(
        Dimens.xmMargin,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              context.strings.create_party_or_join,
              style: const TextStyle(fontSize: Dimens.sFontSize),
            ),
            const _PartiesListConsumer(),
          ],
        ),
      ),
    );
  }
}

class _PartiesListConsumer extends ConsumerWidget {
  const _PartiesListConsumer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(top: Dimens.xmMargin),
      child: ref.watch(partiesStreamProvider).when(
            data: (snapshot) {
              return _PartiesListContent(snapshot: snapshot);
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          ),
    );
  }
}

class _PartiesListContent extends StatelessWidget {
  const _PartiesListContent({required this.snapshot});

  final QuerySnapshot<Object?> snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final id = snapshot.docs[index].id;
        return ListTile(
          title: Text(
            id,
            style: const TextStyle(fontSize: Dimens.xsFontSize),
          ),
          onTap: () {
            _showPartyPasswordDialog(context, id);
          },
        );
      },
    );
  }

  Future<void> _showPartyPasswordDialog(
    BuildContext context,
    String partyName,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return PartyPasswordDialog(partyName: partyName);
      },
    );
  }
}
