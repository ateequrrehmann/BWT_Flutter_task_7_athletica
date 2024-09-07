

import 'package:athletica/models/group_model/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/phone_service/phone_service.dart';

final groupFetcherProvider=FutureProvider<List<GroupModel>>((ref)async{
  final PhoneService phoneService = PhoneService();
  String phone = await phoneService.fetchData();
  

  final FirebaseFirestore firestore=FirebaseFirestore.instance;

  final QuerySnapshot snapshot=await firestore.collection('users').doc(phone).collection('groups').get();

  List<GroupModel> group=snapshot.docs.map((doc){
    return GroupModel.fromMap(doc.data() as Map<String, dynamic>);
  }).toList();

  return group;

});