import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pathlly/presentation/viewmodel/lesson_viewmodel.dart';
import 'package:pathlly/data/repositories/lesson_repository.dart';
import 'package:pathlly/core/utils/video_player_page.dart';
import 'package:pathlly/presentation/view/instructor/add_lesson_page.dart';
import 'package:pathlly/presentation/view/instructor/edit_lesson_page.dart';
import 'package:pathlly/data/models/lesson_model.dart';
import '../../../core/utils/youtube_helper.dart';

class InstructorLessonListPage extends ConsumerWidget {
  final String courseId;
  const InstructorLessonListPage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonListProvider(courseId));

    return Scaffold(
      appBar: AppBar(title: const Text("Lessons"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
       )
      ,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddLessonPage(courseId: courseId))),
        child: const Icon(Icons.add),
      ),
      body: lessonsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (lessons) {
          if (lessons.isEmpty) return const Center(child: Text("No lessons yet"));

          return ListView.builder(
            itemCount: lessons.length,
            itemBuilder: (_, i) {
              final Lesson l = lessons[i];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Wide thumbnail
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => VideoPlayerPage(url: l.youtubeUrl, title: l.title)));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          YoutubeHelper.thumbnailUrl(l.youtubeUrl),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[300],
                            height: 200,
                            child: const Center(child: Icon(Icons.broken_image)),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            color: Colors.blue,
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => EditLessonPage(lesson: l)));
                            },
                          ),
                          IconButton(
                            color: Colors.red,
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await LessonRepository().deleteLesson(l.id);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lesson deleted")));
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
