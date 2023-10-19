class CodeLog {
  final int id;
  final String userId;
  final DateTime date;

  const CodeLog({required this.id, required this.userId, required this.date});

  factory CodeLog.fromJson(Map<String, dynamic> json) => CodeLog(
        id: json['id'] as int,
        userId: json['user_id'] as String,
        date: DateTime.parse(json['date'] as String),
      );

  @override
  String toString() => 'CodeLog($id, $userId, $date)';
}
