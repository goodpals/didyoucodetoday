class Profile {
  final String username;

  const Profile({required this.username});

  factory Profile.fromJson(Map<String, dynamic> json) =>
      Profile(username: json['username'] as String);

  Map<String, dynamic> toJson() => {'username': username};
}
