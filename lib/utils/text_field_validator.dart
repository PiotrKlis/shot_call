class TextFieldValidator {
  static String? validate(String? value, String errorMessage) {
    final trimmedValue = value?.trim();
    if (trimmedValue != null && trimmedValue.isEmpty) {
      return errorMessage;
    } else {
      return null;
    }
  }
}
