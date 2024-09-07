import 'package:athletica/models/user_data/user_data.dart';
import 'package:athletica/provider/future_provider/chat_fetcher_provider/chat_fetcher_provider.dart';
import 'package:athletica/provider/stream_provider/user_status_provider/user_status_provider.dart';
import 'package:athletica/services/chat_service/chat_service.dart';
import 'package:athletica/services/phone_service/phone_service.dart';
import 'package:athletica/views/chat/one_to_one_chat/chat_room/widget/message_card.dart';
import 'package:athletica/views/chat/one_to_one_chat/chat_room/widget/send_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../provider/stream_provider/message_provider/message_provider.dart';
import '../../../color/colors.dart';

class ChatRoom extends StatefulWidget {
  final UserData userMap;

  const ChatRoom({super.key, required this.userMap});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final FocusNode myFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  final PhoneService _phoneService = PhoneService();
  String senderPhone = '';
  String receiverPhone = '';
  String roomId = '';

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
    receiverPhone = widget.userMap.number;
    roomId = _chatService.chatRoomId(senderPhone, receiverPhone);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Consumer(builder: (context, ref, child) {
          ref.invalidate(chatFetcherProvider);
          final userStatus =
              ref.watch(userStatusProvider(widget.userMap.number));
          return userStatus.when(
            data: (status) {
              if (status != null) {
                return Column(
                  children: [
                    Text(status.userName),
                    status.isOnline == true
                        ? Text(
                            'Online',
                            style: TextStyle(fontSize: 15.sp),
                          )
                        : Text(
                            'Away',
                            style: TextStyle(fontSize: 15.sp),
                          )
                  ],
                );
              } else {
                return Container();
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) {
              return Center(child: Text('Error: $error'));
            },
          );
        }),
      ),
      body: Column(
        children: [
          Consumer(builder: (context, ref, child) {
            if (roomId.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Expanded(
                child: SizedBox(
                  height: size.height / 1.25.h,
                  width: size.width,
                  child: ref.watch(messageProvider(roomId)).when(
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
                                  roomId: roomId,
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
          SendTextField(
            roomId: roomId,
            userData: widget.userMap,
            scrollController: _scrollController,
          ),
        ],
      ),
    );
  }
}
