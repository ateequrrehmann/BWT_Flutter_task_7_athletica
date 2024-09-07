import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../../models/message_model/message_model.dart';
import '../../../../../services/chat_service/chat_service.dart';
import '../../../../../services/phone_service/phone_service.dart';
import '../../../../color/colors.dart';


class GroupTextField extends StatefulWidget {
  final String roomId;
  final ScrollController scrollController;

  const GroupTextField({
    super.key,
    required this.roomId,
    required this.scrollController,
  });

  @override
  State<GroupTextField> createState() => _SendTextFieldState();
}

class _SendTextFieldState extends State<GroupTextField> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode myFocusNode = FocusNode();
  final ChatService _chatService = ChatService();
  final PhoneService _phoneService = PhoneService();

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    widget.scrollController.animateTo(
      widget.scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });
  }

  void _handleSendMessage() async {
    String fileName = const Uuid().v1();
    String phone = await _phoneService.fetchData();
    MessageModel messageModel = MessageModel(
      sendBy: phone,
      receiveBy: '',
      message: _messageController.text,
      type: 'text',
      time: FieldValue.serverTimestamp(),
      docName: fileName,
    );
    _chatService.onSendGroupMessage(widget.roomId, messageModel);
    _messageController.clear();
    _scrollToBottom();
  }

  void _handleSendImage() async {
    String fileName = const Uuid().v1();
    String phone = await _phoneService.fetchData();
    MessageModel messageModel = MessageModel(
      sendBy: phone,
      receiveBy: '',
      message: '',
      type: 'img',
      time: FieldValue.serverTimestamp(),
      docName: fileName,
    );
    _chatService.getGroupImage(widget.roomId, messageModel, context);
    _messageController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                controller: _messageController,
                obscureText: false,
                enableSuggestions: true,
                focusNode: myFocusNode,
                autocorrect: false,
                cursorColor: Colors.black,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.9),
                ),
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: _handleSendImage,
                          child: const Icon(Icons.photo_sharp),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: _handleSendMessage,
                          child: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                  hintText: "Send message",
                  labelStyle: TextStyle(
                    color: Colors.black.withOpacity(0.9),
                  ),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: sendTextFieldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28.0),
                    borderSide: const BorderSide(
                      width: 0,
                      color: sendTextFieldBorderColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
