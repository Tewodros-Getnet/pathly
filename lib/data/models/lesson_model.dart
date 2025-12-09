import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson {
  final String id;
  final String courseId;
  final String title;
  final String youtubeUrl;
  final DateTime createdAt;

  Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.youtubeUrl,
    required this.createdAt, required description,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "courseId": courseId,
      "title": title,
      "youtubeUrl": youtubeUrl,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory Lesson.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Lesson(
      id: data["id"],
      courseId: data["courseId"],
      title: data["title"],
      youtubeUrl: data["youtubeUrl"],
      createdAt: data["createdAt"] is Timestamp
          ? (data["createdAt"] as Timestamp).toDate()
          : DateTime.parse(data["createdAt"]), description: null,
    );
  }
}
