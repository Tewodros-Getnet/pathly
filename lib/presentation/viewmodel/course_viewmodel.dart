import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/course_model.dart';
import '../../data/repositories/course_repository.dart';

// Provider Riverpod 3.x
final coursesProvider = StreamProvider<List<Course>>((ref) {
  return CourseRepository().getAllCourses();   // live realtime courses
});

final courseViewModelProvider =
NotifierProvider<CourseViewModel, AsyncValue<void>>(() {
  return CourseViewModel();
});

class CourseViewModel extends Notifier<AsyncValue<void>> {
  late final CourseRepository _repo;

  @override
  AsyncValue<void> build() {
    _repo = CourseRepository();
    return const AsyncValue.data(null);  // default idle state
  }
  Future<bool> createCourse(Course course) async {
    state = const AsyncValue.loading();
    try {
      await _repo.createCourse(course);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> addNewCourse({
    required String title,
    required String description,
    required String instructorId,
    List<String> tags = const [],
    String? thumbnailUrl,
  }) async {
    state = const AsyncValue.loading();

    try {
      final course = Course(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        description: description.trim(),
        instructorId: instructorId,
        createdAt: DateTime.now(),
        tags: tags,
        thumbnailUrl: thumbnailUrl, category: '',
        lessonsCount: 0,
      );

      await _repo.createCourse(course);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
  Future<bool> updateCourse(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateCourse(id, data);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteCourse(String id) async {
    try {
      await _repo.deleteCourse(id);
      return true;
    } catch (_) {
      return false;
    }
  }


}
