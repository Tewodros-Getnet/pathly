import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/course_repository.dart';
import '../../viewmodel/course_viewmodel.dart';
import '../../viewmodel/enrollment_viewmodel.dart';
import 'package:pathlly/presentation/view/instructor/instructor_lesson_list_page.dart';

import 'edit_course_page.dart';

class InstructorCourseListView extends ConsumerWidget {
  const InstructorCourseListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("  Courses"),
      centerTitle: true,),
      body: coursesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (courses) {
          if (courses.isEmpty) {
            return const Center(child: Text("No courses yet"));
          }

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (_, i) {
              final course = courses[i];
              final countAsync =
              ref.watch(enrollmentCountProvider(course.id));

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(course.title,style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                  ),),
                  subtitle: countAsync.when(
                    loading: () => const Text("Loading..."),
                    error: (_, __) => const Text("Error"),
                    data: (count) =>
                        Text("👤 $count students enrolled"),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(

                        color: Colors.blue,
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditCoursePage(course: course),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await CourseRepository().deleteCourse(course.id);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            InstructorLessonListPage(courseId: course.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
