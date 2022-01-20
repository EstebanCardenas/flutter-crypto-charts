part of charts_core.extension;

extension DateTimeExtension on DateTime {
  List<String> get months => const [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];

  String monthName([bool shortened = false]) {
    String name = months[month - 1];
    if (shortened) {
      name = name.substring(0, 3);
    }
    return name;
  }

  int get shortenedYear => year % 1000;
}
