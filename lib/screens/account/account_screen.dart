import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shot_call/screens/home/nickname_provider.dart';
import 'package:shot_call/screens/home/party_name_provider.dart';

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
            const Text('Username',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(ref.read(nicknameProvider)),
            const SizedBox(height: 16,),
            const Text('Current party',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(ref.watch(partyNameProvider)),
          ],
        ),
      ),
    );
  }
}
