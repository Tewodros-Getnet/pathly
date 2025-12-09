import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/course_model.dart';
import '../models/enrollment_model.dart';

class EnrollmentRepository {
  final _db = FirebaseFirestore.instance.collection("enrollments");

  /// ENROLL USER
  Future<void> enroll(String courseId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final id = "${user.uid}_$courseId";

    final enrollment = Enrollment(
      id: id,
      userId: user.uid,
      courseId: courseId,
      enrolledAt: DateTime.now(),
    );

    await _db.doc(id).set(enrollment.toMap());
  }

  /// UNENROLL USER
  Future<void> unEnroll(String courseId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final id = "${user.uid}_$courseId";
    await _db.doc(id).delete();
  }


  /// CHECK IF USER IS ENROLLED
  Stream<bool> isEnrolledStream(String courseId) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value(false);

    final id = "${user.uid}_$courseId";

    return _db.doc(id).snapshots().map((d) => d.exists);
  }

  /// For provider use
  Future<bool> isEnrolled(String courseId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final id = "${user.uid}_$courseId";
    final doc = await _db.doc(id).get();

    return doc.exists;
  }

  /// WATCH ENROLLMENT COUNT IN REAL-TIME
  Stream<int> watchEnrollmentCount(String courseId) {
    return _db
        .where("courseId", isEqualTo: courseId)
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  /// GET ENROLLMENT COUNT (ONE TIME)
  Future<int> getEnrollmentCount(String courseId) async {
    final snap =
    await _db.where("courseId", isEqualTo: courseId).get();
    return snap.docs.length;
  }

  /// GET ALL COURSES THE CURRENT USER IS ENROLLED IN
  Stream<List<String>> getEnrolledCourses(String userId) {
    return _db.where("userId", isEqualTo: userId).snapshots().map(
          (snap) => snap.docs.map((d) => d['courseId'] as String).toList(),
    );
  }
  Stream<List<Course>> watchMyEnrolledCourses() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection("enrollments")
        .where("userId", isEqualTo: uid)
        .snapshots()
        .asyncMap((snap) async {
      final courseIds = snap.docs.map((d) => d['courseId']).toList();

      if (courseIds.isEmpty) return [];

      final coursesSnap = await FirebaseFirestore.instance
          .collection("courses")
          .where("id", whereIn: courseIds)
          .get();

      return coursesSnap.docs
          .map((d) => Course.fromMap(d.data()))
          .toList();
    });
  }


}
