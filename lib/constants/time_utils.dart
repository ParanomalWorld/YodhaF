// lib/utils/time_utils.dart
String formatTime12Hour(String timeOfDayString) {
  // Expecting a string like "TimeOfDay(16:45)"
  final cleaned = timeOfDayString.replaceAll(RegExp(r'TimeOfDay\(|\)'), '');
  final parts = cleaned.split(':');
  if (parts.length < 2) return cleaned; // Fallback if format is unexpected

  final int hour = int.parse(parts[0]);
  final int minute = int.parse(parts[1]);

  // Determine the period (AM/PM) and convert hour to 12-hour format.
  final String period = hour >= 12 ? 'pm' : 'am';
  final int hour12 = (hour % 12 == 0) ? 12 : hour % 12;

  return '$hour12:${minute.toString().padLeft(2, '0')} $period';
}
