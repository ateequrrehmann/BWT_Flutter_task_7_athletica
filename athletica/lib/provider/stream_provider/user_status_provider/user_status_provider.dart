import 'package:athletica/models/user_status_model/user_status_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userStatusProvider =
    StreamProvider.family<UserStatusModel?, String>((ref, phoneNo) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(phoneNo)
      .snapshots()
      .map((snapshot) =>
          snapshot.exists ? UserStatusModel.fromMap(snapshot) : null);
});
