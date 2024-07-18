class TextFieldValidator {
  static String? validateIsEmpty(String? value, String errorMessage) {
    value?.trim();
    if (value != null && value.isEmpty) {
      return errorMessage;
    } else {
      return null;
    }
  }
}
