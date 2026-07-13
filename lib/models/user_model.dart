class UserModel {
  final int id;
  final String name;
  final String email;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? json["user_id"],
      name: json["name"],
      email: json["email"],
      createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    );
  }
}