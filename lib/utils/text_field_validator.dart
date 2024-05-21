class TextFieldValidator {
  static String? validateEmail(String value) {
    final emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );

    if (value.isEmpty) {
      return 'Required Field';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    } else {
      return null;
    }
  }

  static String? validatePassword(String value) {
    const minLength = 8;
    final hasUppercase = RegExp('[A-Z]').hasMatch(value);
    final hasLowercase = RegExp('[a-z]').hasMatch(value);
    final hasDigit = RegExp(r'\d').hasMatch(value);

    if (value.isEmpty) {
      return 'Required Field';
    } else if (value.length >= minLength &&
        hasUppercase &&
        hasLowercase &&
        hasDigit) {
      return null;
    } else {
      return 'Password needs to be at least 8 characters, with an uppercase and a number';
    }
  }

  static String? validateSameText(String input, String valueToCompare) {
    if (input.isEmpty) {
      return 'Required Field';
    } else if (input != valueToCompare) {
      return 'Passwords do not match';
    } else {
      return null;
    }
  }

  static String? validateIsEmpty(String? value, String errorMessage) {
    if (value != null && value.isEmpty) {
      return errorMessage;
    } else {
      return null;
    }
  }

  static String? validateNickname(String value) {
    if (value.isEmpty) {
      return 'Required Field';
    } else {
      return null;
    }
  }

  static String? validateDigits(String value) {
    if (value.isEmpty) {
      return null;
    }

    final digitsRegex = RegExp(r'^[0-9]+$');
    if (!digitsRegex.hasMatch(value)) {
      return 'Only digits are allowed';
    }

    return null;
  }

  static String? validateNonZeroDigits(String value) {
    if (value == '0') {
      return 'Value cannot be 0';
    }

    final digitsRegex = RegExp(r'^[0-9]+$');
    if (!digitsRegex.hasMatch(value)) {
      return 'Only digits are allowed';
    }

    return null;
  }
}
