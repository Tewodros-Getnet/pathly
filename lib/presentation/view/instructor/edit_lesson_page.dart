import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pathlly/data/models/lesson_model.dart';
import 'package:pathlly/data/repositories/lesson_repository.dart';

class EditLessonPage extends ConsumerStatefulWidget {
  final Lesson lesson;
  const EditLessonPage({super.key, required this.lesson});

  @override
  ConsumerState<EditLessonPage> createState() => _EditLessonPageState();
}

class _EditLessonPageState extends ConsumerState<EditLessonPage> {
  late TextEditingController titleCtrl;
  late TextEditingController urlCtrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.lesson.title);
    urlCtrl = TextEditingController(text: widget.lesson.youtubeUrl);
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    urlCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = titleCtrl.text.trim();
    final url = urlCtrl.text.trim();
    if (title.isEmpty || url.isEmpty) return;

    setState(() => isLoading = true);

    final updated = Lesson(
      id: widget.lesson.id,
      courseId: widget.lesson.courseId,
      title: title,
      youtubeUrl: url,
      createdAt: widget.lesson.createdAt, description: null,
    );

    try {
      // reuse add (set) which will overwrite same docId
      await LessonRepository().addLesson(updated);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lesson updated")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Lesson"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Title")), const SizedBox(height: 12),
            TextField(controller: urlCtrl, decoration: const InputDecoration(labelText: "YouTube URL")), const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
              onPressed: isLoading ? null : _save,
              child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
