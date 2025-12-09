import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';

class CourseRepository {
  final _db = FirebaseFirestore.instance.collection('courses');

  /// Create a new course
  Future<void> createCourse(Course course) async {
    await _db.doc(course.id).set(course.toMap());
  }

  /// Get all courses in real-time
  Stream<List<Course>> getAllCourses() {
    return _db
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((e) => Course.fromDoc(e)).toList());
  }

  /// Get a single course
  Future<Course?> getCourse(String id) async {
    final doc = await _db.doc(id).get();
    return doc.exists ? Course.fromDoc(doc) : null;
  }

  Future<void> updateCourse(String id, Map<String, dynamic> data) async {
    await _db.doc(id).update(data);
  }

  Future<void> deleteCourse(String id) async {
    await _db.doc(id).delete();
  }

}
