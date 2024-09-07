import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/message_model/message_model.dart';

final groupMessageProvider =
StreamProvider.family<List<MessageModel>, String>((ref, groupId) {
  return FirebaseFirestore.instance
      .collection('groups')
      .doc(groupId)
      .collection('chats')
      .orderBy('time', descending: false)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return MessageModel.fromMap(doc.data());
    }).toList();
  });
});
