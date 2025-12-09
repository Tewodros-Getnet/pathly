import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pathlly/data/repositories/enrollment_repository.dart';
import 'package:pathlly/data/repositories/user_repository.dart';
import 'package:pathlly/presentation/view/student/student_lesson_list_page.dart';
import 'package:pathlly/presentation/viewmodel/course_viewmodel.dart';
import 'package:pathlly/data/models/course_model.dart';
class StudentCourseListView extends ConsumerWidget {
  const StudentCourseListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("All Courses")),
      body: coursesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("Error: $e")),
        data: (courses) {
          if (courses.isEmpty) return const Center(child: Text("No courses yet"));

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (_, i) {
              final Course c = courses[i];
              return Card(
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
                  onTap: () async {
                    final isEnrolled = await EnrollmentRepository().isEnrolled(c.id);

                    if (!isEnrolled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("You must enroll first to view lessons"),
                        ),
                      );
                      return;
                    }

                    // Allowed → Open lesson list
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudentLessonListPage(courseId: c.id),
                      ),
                    );
                  }
                  ,
                    trailing: FutureBuilder<bool>(
                    future: _isEnrolled(c.id),
                    builder: (context, snap) {
                      final enrolled = snap.data ?? false;
                      return ElevatedButton(
                        onPressed: enrolled ? null : () => _enroll(context, c.id),
                        child: Text(enrolled ? "Enrolled" : "Enroll"),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> _isEnrolled(String courseId) async {
    final user = await UserRepository().getCurrentUserData();
    if (user == null) return false;
    return EnrollmentRepository().isEnrolled(courseId);
  }

  Future<void> _enroll(BuildContext context, String courseId) async {
    final user = await UserRepository().getCurrentUserData();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please login")));
      return;
    }
    await EnrollmentRepository().enroll(courseId);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enrolled")));
  }
}
