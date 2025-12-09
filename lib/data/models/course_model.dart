import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String instructorId;
  final DateTime createdAt;
  final List<String> tags;
  final String? thumbnailUrl;
  final String category;
  final int lessonsCount;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorId,
    required this.createdAt,
    required this.tags,
    required this.thumbnailUrl,
    required this.category,
    required this.lessonsCount,
  });

  // ────────────────────────── 🔥 MAIN FIX HERE 🔥 ──────────────────────────
  factory Course.fromMap(Map<String, dynamic> data) {
    return Course(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      instructorId: data['instructorId'],
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.parse(data['createdAt'].toString()),
      tags: List<String>.from(data['tags'] ?? []),
      thumbnailUrl: data['thumbnailUrl'],
      category: data['category'] ?? '',
      lessonsCount: data['lessonsCount'] ?? 0,
    );
  }

  factory Course.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Course.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "instructorId": instructorId,
      "createdAt": createdAt.toIso8601String(), // stored as string
      "tags": tags,
      "thumbnailUrl": thumbnailUrl,
      "category": category,
      "lessonsCount": lessonsCount,
    };
  }
}
