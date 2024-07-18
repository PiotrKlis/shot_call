import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shot_call/common/extensions/context_extensions.dart';
import 'package:shot_call/common/providers/nickname_provider.dart';
import 'package:shot_call/common/providers/party_name_provider.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.strings.nickname,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(ref.read(nicknameProvider)),
            const SizedBox(
              height: 16,
            ),
            Text(
              context.strings.party,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(ref.watch(partyNameProvider)),
          ],
        ),
      ),
    );
  }
}
