import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/lesson_viewmodel.dart';

class AddLessonPage extends ConsumerStatefulWidget {
  final String courseId;
  const AddLessonPage({super.key, required this.courseId});

  @override
  ConsumerState<AddLessonPage> createState() => _AddLessonPageState();
}

class _AddLessonPageState extends ConsumerState<AddLessonPage> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final urlCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(lessonViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Lesson"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Title")),
          TextField(controller: urlCtrl, decoration: const InputDecoration(labelText: "YouTube URL")),

          const Spacer(),

          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
            onPressed: vm.isLoading ? null : () async {
              final ok = await ref.read(lessonViewModelProvider.notifier).addLesson(
                courseId: widget.courseId,
                title: titleCtrl.text,
                description: descCtrl.text,
                youtubeUrl: urlCtrl.text,
              );

              if (ok) Navigator.pop(context);
            },
            child: vm.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Add Lesson",),
          )
        ]),
      ),
    );
  }
}
