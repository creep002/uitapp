import 'package:intl/intl.dart';

List<DateTime> getWeekDays(DateTime currentDate) {
  DateTime monday = currentDate
      .subtract(Duration(days: currentDate.weekday - DateTime.monday));
  List<DateTime> weekDays = [];
  for (int i = 0; i < 7; i++) {
    weekDays.add(monday.add(Duration(days: i)));
  }
  return weekDays;
}

void main() {
  DateTime currentDate = DateTime.now();
  List<DateTime> weekDays = getWeekDays(currentDate);

  for (var day in weekDays) {
    print(DateFormat('yyyy-MM-dd').format(day));
  }
}
