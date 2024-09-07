import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user_data/user_data.dart';

final userFirebaseProvider = FutureProvider<UserData>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final phone = prefs.getString('user_phone');
  final documentSnapshot =
  await FirebaseFirestore.instance.collection('users').doc(phone).get();
  return UserData.fromFirestore(documentSnapshot);
});
