import 'package:athletica/provider/future_provider/group_fetcher_provider/group_fetcher_provider.dart';
import 'package:athletica/views/chat/group_chat/group_screen/widget/group_list_tile.dart';
import 'package:athletica/views/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/chat_loading_tile.dart';
import '../create_group/add_member_screen/add_member_screen.dart';
import '../group_room/group_room.dart';

class GroupChatHomeScreen extends StatefulWidget {
  const GroupChatHomeScreen({super.key});

  @override
  State<GroupChatHomeScreen> createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Groups'),
      ),
      body: Consumer(builder: (context, ref, child) {
        final groups = ref.watch(groupFetcherProvider);
        return groups.when(data: (groupInfo) {
          return groupInfo.isNotEmpty
              ? ListView.builder(
                  itemCount: groupInfo.length,
                  itemBuilder: (context, index) {
                    return GroupListTile(
                        groupModel: groupInfo[index],
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupChatRoom(
                                        groupModel: groupInfo[index],
                                      )));
                        });
                  })
              : const Center(
                  child: Text("No group found"),
                );
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
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddMemberInGroup()));
        },
        tooltip: "Create Group",
        child: const Icon(Icons.create),
      ),
    );
  }
}
