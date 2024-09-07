import 'package:athletica_admin/provider/future_provider/chat_fetcher_provider/chat_fetcher_provider.dart';
import 'package:athletica_admin/views/chat/one_to_one_chat/chat_room/chat_room.dart';
import 'package:athletica_admin/views/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
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
          title: const Text('Chats'),
        ),
        body: Consumer(builder: (context, ref, child) {
          final data = ref.watch(chatFetcherProvider);
          return data.when(data: (chats) {
            return chats.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          print(chats[index]['name']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatRoom(
                                        roomId: chats[index]['name'],
                                      )));
                        },
                        leading: const Icon(Icons.person),
                        title: const Text('See chat of '),
                        subtitle: Text(chats[index]['name']),
                      );
                    },
                    itemCount: chats.length,
                  )
                : const Center(
                    child: Text('No chats found'),
                  );
          }, error: (error, track) {
            return Center(child: Text('checking+$error'));
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
        }));
  }
}
