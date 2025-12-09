import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/course_model.dart';
import '../../viewmodel/course_viewmodel.dart';

class EditCoursePage extends ConsumerStatefulWidget {
  final Course course;
  const EditCoursePage({super.key, required this.course});

  @override
  ConsumerState<EditCoursePage> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends ConsumerState<EditCoursePage> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;
  late List<String> tags;

  final tagCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.course.title);
    descCtrl = TextEditingController(text: widget.course.description);
    tags = List.from(widget.course.tags);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Course"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Description"), maxLines: 3),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: TextField(controller: tagCtrl, decoration: const InputDecoration(labelText: "Add Tag"))),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (tagCtrl.text.trim().isNotEmpty) {
                      setState(() {
                        tags.add(tagCtrl.text.trim());
                        tagCtrl.clear();
                      });
                    }
                  },
                )
              ],
            ),
            Wrap(
              children: tags.map((t) => Chip(label: Text(t), onDeleted: () => setState(() => tags.remove(t)))).toList(),
            ),

            const Spacer(),

            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
              onPressed: () async {
                final ok = await ref.read(courseViewModelProvider.notifier).updateCourse(widget.course.id, {
                  "title": titleCtrl.text.trim(),
                  "description": descCtrl.text.trim(),
                  "tags": tags,
                });

                if (ok) Navigator.pop(context);
              },
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
