import 'package:athletica/services/chat_service/chat_service.dart';
import 'package:athletica/views/chat/widget/chat_text_field.dart';
import 'package:athletica/views/widgets/reusable_snack_bar/reusable_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../models/user_data/user_data.dart';
import '../chat_room/chat_room.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  Map<String, dynamic>? userMap;
  final ChatService _chatService = ChatService();

  void onSearch() async {
    setState(() {
      isLoading = true;
    });
    userMap = await _chatService.onSearch(_searchController);
    setState(() {
      isLoading = false;
    });
    if (userMap == null) {
      reusableSnackBar(context, 'no user found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ChatTextField(
                searchController: _searchController,
                icon: Icons.search,
                onSubmitted: onSearch),
            SizedBox(height: 5.h),
            isLoading
                ? const CircularProgressIndicator()
                : userMap != null
                    ? ListTile(
                        onTap: () {
                          UserData userModel = UserData.fromMap(userMap!);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatRoom(
                                userMap: userModel,
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(userMap!['imageUrl'] ?? ''),
                        ),
                        title: Text(userMap!['userName'] ?? ''),
                        subtitle: Text(userMap!['bio'] ?? ''),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
