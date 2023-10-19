int nowMs() => DateTime.now().millisecondsSinceEpoch;
const oneDayMs = 1000 * 60 * 60 * 24;

extension RoundDownToDay on DateTime {
  DateTime roundDownToDay() => DateTime(year, month, day);
}
