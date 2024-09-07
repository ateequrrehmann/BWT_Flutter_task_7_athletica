import 'package:athletica_admin/views/chat/one_to_one_chat/chat_room/widget/message_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../provider/stream_provider/message_provider/message_provider.dart';
import '../../../color/colors.dart';

class ChatRoom extends StatefulWidget {
  final String roomId;

  const ChatRoom({super.key, required this.roomId});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final FocusNode myFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(backgroundColor: primaryColor, title: Text(widget.roomId)),
      body: Column(
        children: [
          Consumer(builder: (context, ref, child) {
            if (widget.roomId.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Expanded(
                child: SizedBox(
                  height: size.height / 1.25.h,
                  width: size.width,
                  child: ref.watch(messageProvider(widget.roomId)).when(
                        data: (data) {
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final message = data[index];
                              bool isFirstMessage = index == 0;
                              final previousMessage =
                                  index > 0 ? data[index - 1] : null;

                              return MessageCard(
                                  messageModel: message,
                                  roomId: widget.roomId,
                                  previousMessageModel:
                                      previousMessage ?? message,
                                  isFirstMessage: isFirstMessage);
                            },
                          );
                        },
                        loading: () {
                           return const Center(child: CircularProgressIndicator());
                        },
                        error: (error, stack) {
                          return Center(child: Text('Error: $error'));
                        },
                      ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
