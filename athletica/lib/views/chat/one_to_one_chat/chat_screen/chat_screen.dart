import 'package:athletica/provider/future_provider/chat_fetcher_provider/chat_fetcher_provider.dart';
import 'package:athletica/provider/future_provider/group_fetcher_provider/group_fetcher_provider.dart';
import 'package:athletica/views/chat/one_to_one_chat/chat_screen/widget/chat_floating_action_button.dart';
import 'package:athletica/views/chat/one_to_one_chat/chat_screen/widget/chat_list_tile.dart';
import 'package:athletica/views/chat/widget/chat_loading_tile.dart';
import 'package:athletica/views/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../one_to_one_chat/chat_room/chat_room.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  String roomId = '';
  bool isLoading = false;
  List<Map<String, dynamic>> allUsers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Chat'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer(
              builder: (context, ref, child) {
                ref.invalidate(groupFetcherProvider);
                final data = ref.watch(chatFetcherProvider);
                return data.when(data: (user) {
                  if (user.isNotEmpty) {
                    return ListView.builder(
                        itemCount: user.length,
                        itemBuilder: (context, index) {
                          final userInfo = user[index];
                          return ChatListTile(
                              roomId: roomId,
                              user: userInfo,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatRoom(
                                      userMap: userInfo,
                                    ),
                                  ),
                                );
                              });
                        });
                  } else {
                    return const Center(child: Text('No users found'));
                  }
                }, error: (error, track) {
                  return Center(child: Text('checking+$error'));
                }, loading: () {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return const ChatLoadingTile();
                    },
                    itemCount: 6,
                  );
                });
              },
            ),
      floatingActionButton: const ChatFloatingActionButton(),
    );
  }
}
