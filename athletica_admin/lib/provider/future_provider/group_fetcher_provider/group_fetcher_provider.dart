

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/group_model/group_model.dart';

final groupFetcherProvider=FutureProvider<List<GroupModel>>((ref)async{

  final FirebaseFirestore firestore=FirebaseFirestore.instance;

  final QuerySnapshot snapshot=await firestore.collection('groups').get();

  List<GroupModel> group=snapshot.docs.map((doc){
    return GroupModel.fromMap(doc.data() as Map<String, dynamic>);
  }).toList();


  return group;

});

