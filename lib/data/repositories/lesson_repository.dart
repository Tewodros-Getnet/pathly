import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson_model.dart';

class LessonRepository {
  final _db = FirebaseFirestore.instance.collection("lessons");

  Future<void> addLesson(Lesson lesson) async {
    await _db.doc(lesson.id).set(lesson.toMap());
  }
  Future<void> deleteLesson(String id) async {
    await _db.doc(id).delete();
  }
  Stream<List<Lesson>> getLessonsForCourse(String courseId) {
    return _db
        .where("courseId", isEqualTo: courseId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();

        /// ------ SAFE TIMESTAMP PARSING ------
        final createdAtRaw = data["createdAt"];
        DateTime createdAt;

        if (createdAtRaw is Timestamp) {
          createdAt = createdAtRaw.toDate();
        } else if (createdAtRaw is String) {
          createdAt = DateTime.tryParse(createdAtRaw) ?? DateTime.now();
        } else {
          createdAt = DateTime.now();
        }

        return Lesson(
          id: data["id"] ?? doc.id,
          courseId: data["courseId"] ?? "",
          title: data["title"] ?? "",
          description: data["description"] ?? "",
          youtubeUrl: data["youtubeUrl"] ?? "",
          createdAt: createdAt,
        );
      }).toList();
    });
  }
}
