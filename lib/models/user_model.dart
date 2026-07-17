class UserModel {
  final int id;
  final String name;
  final String email;
  final DateTime? createdAt;

  final int currentStreak;
  final int longestStreak;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
    required this.currentStreak,
    required this.longestStreak,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? json["user_id"],
      name: json["name"],
      email: json["email"],
      createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
      currentStreak: json["current_streak"] ?? 0,
      longestStreak: json["longest_streak"] ?? 0,
    );
  }
}