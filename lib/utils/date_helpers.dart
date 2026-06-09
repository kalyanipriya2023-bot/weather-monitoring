library;

import 'package:intl/intl.dart';

class DateHelpers {
  DateHelpers._();

  static String formatFullDate(DateTime dt) => DateFormat('EEEE, MMMM d, yyyy').format(dt);
  static String formatShortDate(DateTime dt) => DateFormat('MMM d').format(dt);
  static String formatTime(DateTime dt) => DateFormat('hh:mm a').format(dt);
  static String formatHour(DateTime dt) => DateFormat('ha').format(dt).toLowerCase();
  static String formatDayName(DateTime dt) => DateFormat('EEE').format(dt);
  static String formatDayMonth(DateTime dt) => DateFormat('d MMM').format(dt);
  static String formatMonthYear(DateTime dt) => DateFormat('MMMM yyyy').format(dt);

  static String relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formatShortDate(dt);
  }

  static bool isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  static bool isTomorrow(DateTime dt) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return dt.year == tomorrow.year && dt.month == tomorrow.month && dt.day == tomorrow.day;
  }

  static String smartDayLabel(DateTime dt) {
    if (isToday(dt)) return 'Today';
    if (isTomorrow(dt)) return 'Tomorrow';
    return formatDayName(dt);
  }
}
