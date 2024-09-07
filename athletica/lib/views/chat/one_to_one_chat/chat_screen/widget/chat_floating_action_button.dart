import 'package:athletica/views/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../group_chat/group_screen/group_screen.dart';
import '../../new_chat_screen/new_chat_screen.dart';


class ChatFloatingActionButton extends StatelessWidget {
  const ChatFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.chat, color: darkOrange,),
      onPressed: () {
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(20.w, 67.h, 0, 20.w),
          items: [
            const PopupMenuItem(
              value: 'newChat',
              padding: EdgeInsets.zero,
              child: Tooltip(
                message: "New Chat",
                child: Center(child: Icon(Icons.person, color: darkOrange,)),
              ), // Remove extra padding
            ),
            const PopupMenuItem(
              value: 'groupChat',
              padding: EdgeInsets.zero,
              child: Tooltip(
                message: "Group Chat",
                child: Center(child: Icon(Icons.group, color: darkOrange,)),
              ), // Remove extra padding
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
        ).then((value) {
          if (value == 'newChat') {
            // Navigate to NewChatScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewChatScreen()),
            );
          } else if (value == 'groupChat') {
            // Navigate to GroupChatHomeScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GroupChatHomeScreen()),
            );
          }
        });
      },
    );
  }
}
