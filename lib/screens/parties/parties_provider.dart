import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final partiesStreamProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance.collection('parties').snapshots();
});
