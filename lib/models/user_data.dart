import 'package:didyoucodetoday/models/code_log.dart';
import 'package:didyoucodetoday/models/profile.dart';
import 'package:didyoucodetoday/utils/date.dart';

class UserData {
  final String id;
  final Profile profile;
  final List<CodeLog> codeLogs;
  final int? streak;

  bool get codedToday => codeLogs.any((e) => e.date
      .roundDownToDay()
      .isAtSameMomentAs(DateTime.now().roundDownToDay()));

  const UserData({
    required this.id,
    required this.profile,
    this.codeLogs = const [],
    this.streak,
  });

  UserData copyWith({
    String? id,
    Profile? profile,
    List<CodeLog>? codeLogs,
    int? streak,
  }) {
    if (codeLogs != null && streak == null) {
      streak = _calculateStreak(codeLogs);
    }
    return UserData(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      codeLogs: codeLogs ?? this.codeLogs,
      streak: streak ?? this.streak,
    );
  }

  int _calculateStreak(List<CodeLog> logs) {
    DateTime day = DateTime.now().roundDownToDay();
    int streak = 0;
    bool firstDay = true;
    // ehh i'll make this less ugly later maybe
    for (final log in logs) {
      if (log.date.isBefore(day)) {
        if (!firstDay) {
          break;
        }
      } else {
        streak++;
      }
      firstDay = false;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }
}
