import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final partyParticipantsStreamProvider =
    StreamProvider.autoDispose.family<List<String>, String>((ref, partyId) {
  return FirebaseFirestore.instance
      .collection('parties')
      .doc(partyId)
      .snapshots()
      .map(
        (snapshot) => (snapshot.data()!['participants'] as List<dynamic>)
            .map((item) => item as String)
            .toList(),
      );
});
