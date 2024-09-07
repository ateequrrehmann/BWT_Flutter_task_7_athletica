import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../models/message_model/message_model.dart';
import '../../../../../services/chat_service/chat_service.dart';
import '../../../../../services/phone_service/phone_service.dart';
import '../../../../color/colors.dart';
import '../../../show_image/show_image.dart';

class GroupMessageCard extends StatefulWidget {
  final MessageModel messageModel;
  final String roomId;
  final MessageModel previousMessageModel;
  final bool isFirstMessage;

  const GroupMessageCard(
      {super.key,
      required this.messageModel,
      required this.roomId,
      required this.previousMessageModel,
      this.isFirstMessage = false});

  @override
  State<GroupMessageCard> createState() => _GroupMessageCardState();
}

class _GroupMessageCardState extends State<GroupMessageCard> {
  final ChatService _chatService = ChatService();
  final PhoneService _phoneService = PhoneService();
  String? senderPhone;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  bool shouldShowDate() {
    if (widget.messageModel.time == null ||
        widget.previousMessageModel.time == null) {
      return false; // Or other logic to handle null timestamps
    }
    String currentMessageDate =
        _chatService.formatDate(widget.messageModel.time);
    String previousMessageDate =
        _chatService.formatDate(widget.previousMessageModel.time);
    return currentMessageDate != previousMessageDate;
  }

  Future<void> fetchData() async {
    String fetchedPhone = await _phoneService.fetchData();
    setState(() {
      senderPhone = fetchedPhone;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;


    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (widget.isFirstMessage)
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
            decoration: BoxDecoration(
              color: messageDateShowColor,
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Text(
              _chatService.formatDate(widget.messageModel.time),
              style: const TextStyle(
                  color: messageTextShowColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      if (shouldShowDate())
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
            decoration: BoxDecoration(
              color: messageDateShowColor,
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Text(
              _chatService.formatDate(widget.messageModel.time),
              style: const TextStyle(
                  color: messageTextShowColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      widget.messageModel.type == "text"
          ? Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.7.w,
                ),
                child: IntrinsicWidth(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w),
                      color: messageTileColor2,
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.messageModel.sendBy,
                          style: const TextStyle(
                              decoration: TextDecoration.underline),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.messageModel.message,
                              style: TextStyle(
                                color: messageTextTileColor2,
                                fontWeight: FontWeight.w500,
                                fontSize: 17.sp,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            _chatService
                                .getMessageTime(widget.messageModel.time),
                            style: TextStyle(
                              color: messageTileColor2,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : widget.messageModel.type == 'img'
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin:
                      EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.w),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: size.width * 0.7.w,
                    ),
                    child: IntrinsicWidth(
                        child: widget.messageModel.sendBy != senderPhone
                            ? InkWell(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShowImage(
                                              imageUrl: widget
                                                  .messageModel.message)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.w),
                                    color: messageTileColor2,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.h, horizontal: 3.w),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        widget.messageModel.sendBy,
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Photo',
                                            style: TextStyle(
                                              color: messageTextTileColor2,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17.sp,
                                            ),
                                          ),
                                          const Icon(Icons.image)
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          _chatService.getMessageTime(
                                              widget.messageModel.time),
                                          style: TextStyle(
                                            color: messageTextTileColor2,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShowImage(
                                              imageUrl: widget
                                                  .messageModel.message)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.w),
                                    color: messageTileColor2,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.h, horizontal: 3.w),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        widget.messageModel.sendBy,
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Photo',
                                            style: TextStyle(
                                              color: messageTileColor2,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17.sp,
                                            ),
                                          ),
                                          const Icon(Icons.image)
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          _chatService.getMessageTime(
                                              widget.messageModel.time),
                                          style: TextStyle(
                                            color: messageTextTileColor2,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                  ),
                )
              : Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                    decoration: BoxDecoration(
                      color: messageDateShowColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.messageModel.message,
                      style: const TextStyle(
                          color: messageTextShowColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
    ]);
  }
}
