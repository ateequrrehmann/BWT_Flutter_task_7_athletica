import 'package:athletica/models/user_data/user_data.dart';
import 'package:athletica/services/chat_service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/phone_service/phone_service.dart';

final chatFetcherProvider = FutureProvider<List<UserData>>((ref) async {
  final PhoneService phoneService = PhoneService();
  final ChatService chatService = ChatService();

  String phone = await phoneService.fetchData();
  List<UserData> filteredUsers = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  QuerySnapshot userSnapshot = await firestore.collection('users').get();

  List<UserData> users = userSnapshot.docs
      .map((doc) => UserData.fromFirestore(doc))
      .where((user) => user.number != phone)
      .toList();

  for (var user in users) {
    String roomId = chatService.chatRoomId(phone, user.number);

    QuerySnapshot chatSnapshot = await firestore
        .collection('chatroom')
        .doc(roomId)
        .collection('chats')
        .get();

    if (chatSnapshot.docs.isNotEmpty) {
      filteredUsers.add(user);
    } else {}
  }

  return filteredUsers;
});
