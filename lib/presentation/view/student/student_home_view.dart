import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pathlly/presentation/view/student/student_course_list_view.dart';
import '../../viewmodel/auth_viewmodel.dart';
import 'my_course_view.dart';

class StudentHomeView extends ConsumerWidget {
  const StudentHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: const Text("Pathlly — Student"),
          bottom: const TabBar(
            labelColor: Colors.white,            // selected tab text color
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: "All Courses",),
              Tab(text: "My Courses"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () =>
                  ref.read(authViewModelProvider.notifier).logout(),
            ),
          ],
        ),
        body: const TabBarView(

          children: [
            StudentCourseListView(),   // <-- All Courses
            MyCoursesView(),          // <-- Enrolled Only
          ],
        ),
      ),
    );
  }
}
