import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/lesson_model.dart';
import '../../data/repositories/lesson_repository.dart';

final lessonListProvider = StreamProvider.family<List<Lesson>, String>((ref, courseId) {
  return LessonRepository().getLessonsForCourse(courseId);
});

final lessonViewModelProvider =
NotifierProvider<LessonViewModel, AsyncValue<void>>(() => LessonViewModel());

class LessonViewModel extends Notifier<AsyncValue<void>> {
  late final LessonRepository _repo;

  @override
  AsyncValue<void> build() {
    _repo = LessonRepository();
    return const AsyncValue.data(null);
  }

  Future<bool> addLesson({
    required String courseId,
    required String title,
    required String description,
    required String youtubeUrl,
  }) async {
    state = const AsyncValue.loading();

    try {
      final lesson = Lesson(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        courseId: courseId,
        title: title.trim(),
        youtubeUrl: youtubeUrl.trim(),
        createdAt: DateTime.now(), description: null,
      );

      await _repo.addLesson(lesson);
      state = const AsyncValue.data(null);
      return true;

    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
