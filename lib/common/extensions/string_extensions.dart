extension StringExtensions on String {
  String removeAllWhiteSpaces() => replaceAll(RegExp(r'\s+'), '');

  String removeSpecialChars() => replaceAll(RegExp(r'[ąćęłńóśżź]'), '');
}
