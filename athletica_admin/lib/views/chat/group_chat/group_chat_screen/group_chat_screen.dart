
import 'package:athletica_admin/views/chat/group_chat/group_chat_screen/widget/group_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../provider/future_provider/group_fetcher_provider/group_fetcher_provider.dart';
import '../../../color/colors.dart';
import '../group_room/group_room.dart';


class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
      }),
    );
  }
}
