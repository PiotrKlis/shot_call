import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/data/firestore_constants.dart';

final partyParticipantsStreamProvider =
    StreamProvider.autoDispose.family<List<String>, String>((ref, partyId) {
  return FirebaseFirestore.instance
      .collection(FirestoreConstants.parties)
      .doc(partyId)
      .snapshots()
      .map(
        (snapshot) =>
            (snapshot.data()![FirestoreConstants.participants] as List<dynamic>)
                .map((item) => item as String)
                .toList(),
      );
});
