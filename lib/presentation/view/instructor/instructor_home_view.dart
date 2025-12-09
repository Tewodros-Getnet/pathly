import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pathlly/presentation/view/instructor/add_course_page.dart';
import 'package:pathlly/presentation/view/instructor/instructor_course_list_view.dart';
import '../../viewmodel/auth_viewmodel.dart';

class InstructorHomeView extends ConsumerWidget {
  const InstructorHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Pathly [ Instructor ]'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authViewModelProvider.notifier).logout(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddCoursePage())),
        child: const Icon(Icons.add),
      ),
      body: const InstructorCourseListView(),
    );
  }
}
