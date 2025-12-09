import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/course_model.dart';
import '../../data/repositories/enrollment_repository.dart';

final isEnrolledProvider = StreamProvider.family<bool, String>((ref, courseId) {
  return EnrollmentRepository().isEnrolledStream(courseId);
});

final enrollmentCountProvider = StreamProvider.family<int, String>((ref, courseId) {
  return EnrollmentRepository().watchEnrollmentCount(courseId);
});
final myCoursesProvider = StreamProvider<List<Course>>((ref) {
  return EnrollmentRepository().watchMyEnrolledCourses();
});
