
extension StringExtension on String {

  DateTime toDate() {
    return DateTime.parse(this);
  }
}