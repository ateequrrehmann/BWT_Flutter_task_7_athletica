import 'package:athletica/models/group_model/group_model.dart';
import 'package:flutter/material.dart';

class GroupListTile extends StatelessWidget {
  final GroupModel groupModel;
  final VoidCallback onTap;
  const GroupListTile({super.key, required this.groupModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(Icons.group),
      title: Text(groupModel.name),
    );
  }
}
