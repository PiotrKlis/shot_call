import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shot_call/data/firestore_constants.dart';

final partiesStreamProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance
      .collection(FirestoreConstants.parties)
      .snapshots();
});
