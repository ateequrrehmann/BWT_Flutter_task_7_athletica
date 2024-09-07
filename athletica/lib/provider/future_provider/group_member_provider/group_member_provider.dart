

import 'package:athletica/models/user_data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupMemberProvider=FutureProvider.family<List<UserData>, String>((ref, roomId)async{
  final docSnapshot=await FirebaseFirestore.instance.collection('groups').doc(roomId).get();
  final List<dynamic> membersData=docSnapshot.data()?['members']??[];

  List<UserData> member=membersData.map((memberData){
    return UserData.fromMap(memberData as Map<String, dynamic>);
  }).toList();

  return member;
});