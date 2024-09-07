import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final chatFetcherProvider = FutureProvider<List>((ref) async {

  List chats;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot chatSnapshot = await firestore
        .collection('chatroom')
        .get();

    chats=chatSnapshot.docs.map((doc){
      return {
        'name': doc['name'],
      };
    }).toList();

    return chats;
});
