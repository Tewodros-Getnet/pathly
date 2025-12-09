import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pathlly/presentation/view/student/student_lesson_list_page.dart';
import '../../viewmodel/enrollment_viewmodel.dart';

class MyCoursesView extends ConsumerWidget {
  const MyCoursesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrolledCourses = ref.watch(myCoursesProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16), // Space below AppBar/TabBar
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ---- TITLE ----
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Enrolled Courses",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ---- LIST OF COURSES ----
            Expanded(
              child: enrolledCourses.when(
                data: (courses) {
                  if (courses.isEmpty) {
                    return const Center(
                      child: Text("You haven't enrolled in any courses yet."),
                    );
                  }

                  return ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (_, i) {
                      final c = courses[i];
                      return  Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(c.title,style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Roboto',
                          ),),
                          subtitle: Text(
                            c.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    StudentLessonListPage(courseId: c.id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
                loading: () =>
                const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
