import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/lesson_repository.dart';
import '../../../data/models/lesson_model.dart';
import 'package:pathlly/core/utils/youtube_helper.dart';
import '../../../core/utils/video_player_page.dart';

class StudentLessonListPage extends ConsumerWidget {
  final String courseId;

  const StudentLessonListPage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonStream = LessonRepository().getLessonsForCourse(courseId);

    return Scaffold(
      appBar: AppBar(title: const Text("Lessons"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,),
      body: StreamBuilder<List<Lesson>>(
        stream: lessonStream,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final lessons = snap.data!;
          if (lessons.isEmpty) {
            return const Center(child: Text("No lessons yet"));
          }

          return ListView.builder(
            itemCount: lessons.length,
            itemBuilder: (_, i) {
              final lesson = lessons[i];
              final thumbUrl = YoutubeHelper.thumbnailUrl(lesson.youtubeUrl);



              return Card(
                margin: const EdgeInsets.all(12),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerPage(
                          url: lesson.youtubeUrl,
                          title: lesson.title,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // THUMBNAIL
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          thumbUrl,
                          width: double.infinity,
                          height: 155,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // TITLE
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          lesson.title,
                          maxLines: 3,

                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
