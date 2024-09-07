import 'package:flutter/material.dart';

class EditAlertDialog extends StatelessWidget {
  final String section;
  final TextEditingController controller;
  const EditAlertDialog({super.key, required this.section, required this.controller});

  @override
  Widget build(BuildContext context) {
     return AlertDialog(
          title: Text('Edit $section'),
          content: TextField(
            controller: controller,
            maxLines: section == 'description' || section== "details" ? 5 : 1,
            decoration: InputDecoration(
              hintText: 'Enter new $section',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
  }
}
