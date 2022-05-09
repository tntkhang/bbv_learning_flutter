import 'package:intl/intl.dart';

const String dateFormatter = 'MMMM dd, y';

extension DateExtension on DateTime {

  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }
}