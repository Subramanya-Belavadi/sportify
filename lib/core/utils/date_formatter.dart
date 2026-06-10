import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final _apiFormat = DateFormat('yyyy-MM-dd');
  static final _displayFormat = DateFormat('EEE, MMM d');
  static final _timeFormat = DateFormat('h:mm a');

  static String toApiFormat(DateTime date) => _apiFormat.format(date);
  static String toDisplayFormat(DateTime date) => _displayFormat.format(date);

  static String toTimeDisplay(String time) {
    final parts = time.split(':');
    final dt = DateTime(0, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
    return _timeFormat.format(dt);
  }

  static String slotRange(String start, String end) =>
      '${toTimeDisplay(start)} – ${toTimeDisplay(end)}';
}
