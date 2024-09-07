import 'package:athletica/models/group_model/group_model.dart';
import 'package:athletica/provider/stream_provider/group_message_provider/group_message_provider.dart';
import 'package:athletica/views/chat/group_chat/group_room/widget/group_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../services/phone_service/phone_service.dart';
import '../../../color/colors.dart';
import 'widget/group_message_card.dart';
import '../group_info/group_info.dart';

class GroupChatRoom extends StatefulWidget {
  final GroupModel groupModel;

  const GroupChatRoom({super.key, required this.groupModel});

  @override
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {
  final FocusNode myFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final PhoneService _phoneService = PhoneService();
  String senderPhone = '';
  String receiverPhone = '';

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollDown();
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchData();
      setState(() {});
      Future.delayed(
        const Duration(milliseconds: 300),
        () => scrollDown(),
      );
    });
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  fetchData() async {
    senderPhone = await _phoneService.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.groupModel.name),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupInfo(
                              groupName: widget.groupModel.name,
                              groupId: widget.groupModel.id,
                            )));
              },
              icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Consumer(builder: (context, ref, child) {
            if (widget.groupModel.id.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Expanded(
                child: SizedBox(
                  height: size.height / 1.25.sp,
                  width: size.width,
                  child: ref.watch(groupMessageProvider(widget.groupModel.id)).when(
                        data: (data) {
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final message = data[index];
                              bool isFirstMessage = index == 0;
                              final previousMessage =
                                  index > 0 ? data[index - 1] : null;
                              return GroupMessageCard(
                                  messageModel: message,
                                  roomId: widget.groupModel.id,
                                  previousMessageModel:
                                      previousMessage ?? message,
                                  isFirstMessage: isFirstMessage);
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) {
                          return Center(child: Text('Error: $error'));
                        },
                      ),
                ),
              );
            }
          }),
          GroupTextField(
            roomId: widget.groupModel.id,
            scrollController: _scrollController,
          ),
        ],
      ),
    );
  }
}
