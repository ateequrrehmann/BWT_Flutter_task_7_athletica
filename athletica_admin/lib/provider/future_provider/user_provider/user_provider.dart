
import 'package:athletica_admin/models/user_data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider=FutureProvider<List<UserData>>((ref) async{
  final firestore=FirebaseFirestore.instance;
  QuerySnapshot snapshot = await firestore.collection('users').get();
  List<UserData> userData=snapshot.docs.map((data){
    return UserData.fromFirestore(data);
  }).toList();
  return userData;
});