import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shot_call/data/firestore_constants.dart';

class TextFieldValidator {
  static String? validate(String? value, String errorMessage) {
    final trimmedValue = value?.trim();
    if (trimmedValue != null && trimmedValue.isEmpty) {
      return errorMessage;
    } else {
      return null;
    }
  }

  static Future<String?> validatePartyName(
      String? value, String errorMessage) async {
    final trimmedValue = value?.trim();
    if (trimmedValue != null && trimmedValue.isEmpty) {
      return errorMessage;
    } else {
      final partyName = await FirebaseFirestore.instance
          .collection(FirestoreConstants.parties)
          .doc(trimmedValue)
          .get();
      if (partyName.exists) {
        return 'Party already exists';
      }

      return null;
    }
  }
}
