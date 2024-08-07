extension StringExtensions on String {
  String removeAllWhiteSpaces() => replaceAll(RegExp(r'\s+'), '');
}
