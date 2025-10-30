// lib/models/user_model.dart
class User {
  final String id;
  final String username;
  final String email;
  final String userType; // 'user' 或 'business'
  final DateTime? createdAt;
  
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.userType,
    this.createdAt,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      userType: json['userType'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'userType': userType,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}