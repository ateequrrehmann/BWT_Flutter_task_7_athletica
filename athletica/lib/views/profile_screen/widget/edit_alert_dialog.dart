import 'package:flutter/material.dart';

import '../../color/colors.dart';

class EditAlertDialog{
  Future<String> editDialog(BuildContext context, String title) async{
      String newValue = "";
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: profilePrimaryColor,
          title: Text("Edit $title"),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter new $title",
            ),
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(newValue);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );
      return newValue;
  }
}