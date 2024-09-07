import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/message_model/message_model.dart';

final messageProvider =
    StreamProvider.family<List<MessageModel>, String>((ref, roomId) {
  return FirebaseFirestore.instance
      .collection('chatroom')
      .doc(roomId)
      .collection('chats')
      .orderBy('time', descending: false)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return MessageModel.fromMap(doc.data());
    }).toList();
  });
});
