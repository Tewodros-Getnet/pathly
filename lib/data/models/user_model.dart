import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? photoUrl;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.photoUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "role": role,
      "photoUrl": photoUrl,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  // 🟦 Convert Firestore Document → User
  factory AppUser.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser.fromMap(data);
  }

  // 🟩 Convert Map → User
  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      id: data["id"],
      email: data["email"],
      name: data["name"],
      role: data["role"],
      photoUrl: data["photoUrl"],
      createdAt: DateTime.parse(data["createdAt"]),
    );
  }
}
