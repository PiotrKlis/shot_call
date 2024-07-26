class TextFieldValidator {
  static String? validate(String? value, String errorMessage) {
    value?.trim();
    if (value != null && value.isEmpty) {
      return errorMessage;
    } else {
      return null;
    }
  }
}
