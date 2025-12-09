import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pathlly/presentation/viewmodel/course_viewmodel.dart';
import '../../../data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/course_model.dart';
import '../../../data/repositories/course_repository.dart';

class AddCoursePage extends ConsumerStatefulWidget {
  const AddCoursePage({super.key});

  @override
  ConsumerState<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends ConsumerState<AddCoursePage> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  List<String> tags = [];
  final TextEditingController tagCtrl = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(courseViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Create New Course"),
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue,),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: "Course Title",
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),
            const SizedBox(height: 20),

            // TAG INPUT
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: tagCtrl,
                    decoration:
                    const InputDecoration(labelText: "Add tag (optional)"),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (tagCtrl.text.trim().isNotEmpty) {
                      setState(() {
                        tags.add(tagCtrl.text.trim());
                        tagCtrl.clear();
                      });
                    }
                  },
                  icon: const Icon(Icons.add),
                )
              ],
            ),

            // TAG DISPLAY
            Wrap(
              children: tags
                  .map((t) => Chip(
                label: Text(t),
                onDeleted: () => setState(() => tags.remove(t)),
              ))
                  .toList(),
            ),

            const Spacer(),

            // SUBMIT BUTTON
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),

              onPressed: courseState.isLoading
                  ? null
                  : () async {
                final user = await UserRepository().getCurrentUserData();

                if (user == null) return;

                final success = await ref
                    .read(courseViewModelProvider.notifier)
                    .addNewCourse(
                  title: titleCtrl.text,
                  description: descCtrl.text,
                  instructorId: user.id,
                  tags: tags,
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                        "Course Created 🎉")),
                  );
                  Navigator.pop(context);
                }

              },
              child: courseState.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Create Course"),
            )
          ],
        ),
      ),
    );
  }
}
