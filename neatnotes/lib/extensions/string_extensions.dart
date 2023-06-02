//Adapted from https://stackoverflow.com/questions/29628989/how-to-capitalize-the-first-letter-of-a-string-in-dart

//Capitalises a string, making only the first letter caps
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}