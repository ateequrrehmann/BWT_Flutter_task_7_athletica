import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/message_model/message_model.dart';
import '../../models/user_data/user_data.dart';
import '../../views/widgets/reusable_snack_bar.dart';
import '../phone_service/phone_service.dart';



class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PhoneService _phoneService = PhoneService();
  File? imageFile;
  int status = 0;

  String chatRoomId(String user1, String user2) {
    List<String> users = [user1, user2];
    users.sort();
    return "${users[0]}${users[1]}";
  }

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('dd MMM yyyy').format(date);
  }

  Future<Map<String, dynamic>?> onSearch(
      TextEditingController searchController) async {

    String? completePhone;
    Map<String, dynamic>? userMap;
    String inputPhone = searchController.text;

    if (inputPhone.startsWith('0')) {
      inputPhone = inputPhone.substring(1);
      completePhone = '+92$inputPhone';
    } else if (inputPhone.startsWith('+92')) {
      completePhone = searchController.text;
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final result = await firestore
          .collection('users')
          .where("phone", isEqualTo: completePhone)
          .get();

      if (result.docs.isNotEmpty) {
        userMap = result.docs[0].data();
      } else {
        userMap = null;
      }
    } catch (e) {
      userMap = null;
    }

    return userMap;
  }


  String getMessageTime(Timestamp? dateTime) {
    if (dateTime == null) {
      return '';
    }
    DateTime date = dateTime.toDate();
    String formattedTime = DateFormat('hh:mm a').format(date);
    return formattedTime;
  }

  onSendMessage(String roomId, MessageModel messages) async {
    await _firestore.collection('chatroom').doc(roomId).set({'name': roomId});
    await _firestore
        .collection('chatroom')
        .doc(roomId)
        .collection('chats')
        .doc(messages.docName)
        .set({
      "sendBy": messages.sendBy,
      "receiveBy": messages.receiveBy,
      "message": messages.message,
      "type": messages.type,
      "status": '0',
      "docName": messages.docName,
      "time": FieldValue.serverTimestamp()
    });
  }

  Future getImage(
      String roomId, MessageModel messages, BuildContext context) async {
    ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage(roomId, messages, context);
      }
    });
  }

  Future uploadImage(
      String roomId, MessageModel messages, BuildContext context) async {
    // Add document to Firestore with type 'img' and empty message
    await _firestore
        .collection('chatroom')
        .doc(roomId)
        .collection('chats')
        .doc(messages.docName)
        .set({
      "sendBy": messages.sendBy,
      "receiveBy": messages.receiveBy,
      "message": '',
      "type": messages.type,
      "status": '0',
      "docName": messages.docName,
      "time": FieldValue.serverTimestamp()
    });

    var ref = FirebaseStorage.instance
        .ref()
        .child('userImages')
        .child('${messages.docName}.jpg');

    try {
      // Try to upload the image
      var uploadTask = await ref.putFile(imageFile!);

      // Get the image URL if upload is successful
      String imageUrl = await uploadTask.ref.getDownloadURL();

      // Update the Firestore document with the image URL
      await _firestore
          .collection('chatroom')
          .doc(roomId)
          .collection('chats')
          .doc(messages.docName)
          .update({"message": imageUrl});
    } catch (error) {
      status = 0;

      // Optionally, update the document to indicate the failure
      await _firestore
          .collection('chatroom')
          .doc(roomId)
          .collection('chats')
          .doc(messages.docName)
          .delete();
      reusableSnackBar(context, 'Failed to send image');
    }
  }

  void createGroup(String groupName, List<UserData> membersList) async {
    String groupId = const Uuid().v1();
    List<Map<String, dynamic>> membersMapList =
        membersList.map((member) => member.toMap()).toList();

    await _firestore.collection('groups').doc(groupId).set({
      'members': membersMapList,
      'id': groupId,
      'name': groupName,
      'totalMembers': membersList.length
    });

    for (int i = 0; i < membersList.length; i++) {
      String phone = membersList[i].number;
      await _firestore
          .collection('users')
          .doc(phone)
          .collection('groups')
          .doc(groupId)
          .set({'name': groupName, 'id': groupId});
    }

    final adminPhone = await _phoneService.fetchData();
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(adminPhone).get();
    final adminName = documentSnapshot.get('userName');

    await _firestore.collection('groups').doc(groupId).collection('chats').add({
      'message': '$adminName Created this Group.',
      'type': 'notify',
      'time': FieldValue.serverTimestamp(),
      'sendBy': '',
      'receiveBy': '',
      'docName': '',
      'status': '0',
    });
  }

  Future<String> fetchPhone() async {
    return await _phoneService.fetchData();
  }

  bool checkAdmin(List<UserData> membersList, String adminPhone) {
    bool isAdmin = false;
    for (var element in membersList) {
      if (element.number == adminPhone) {
        isAdmin = element.isAdmin!;
      }
    }
    return isAdmin;
  }

  removeUser(int index, String phone, List<UserData> membersList,
      String groupId) async {
    if (checkAdmin(membersList, phone)) {
      if (membersList[index].isAdmin == false) {
        String phone = membersList[index].number;
        membersList.removeAt(index);

        await _firestore.collection('groups').doc(groupId).update({
          'members': membersList,
        });

        await _firestore
            .collection('users')
            .doc(phone)
            .collection('groups')
            .doc(groupId)
            .delete();

        return true;
      }
    } else {
      return false;
    }
  }

  onLeaveGroup(String phone, List<UserData> membersList, String groupId) async {
    if (!checkAdmin(membersList, phone)) {
      membersList.removeWhere((member) => member.number == phone);
      List<Map<String, dynamic>> membersMapList =
          membersList.map((member) => member.toMap()).toList();

      await _firestore.collection('groups').doc(groupId).update({
        'members': membersMapList,
      });

      await _firestore
          .collection('users')
          .doc(phone)
          .collection('groups')
          .doc(groupId)
          .delete();

      return true;
    } else {
      return false;
    }
  }

  onAddMembers(List<UserData> membersList, UserData userMap, String groupId,
      String groupName) async {
    bool isAlreadyExist = false;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i].number == userMap.number) {
        isAlreadyExist = true;
      }
    }

    if (!isAlreadyExist) {
      membersList.add(UserData.fromMap({
        "name": userMap.name,
        'phone': userMap.number,
        'imageUrl': userMap.imageUrl!,
        'bio': userMap.bio!,
        'uid': userMap.userId,
        'isAdmin': false,
        'email': userMap.email
      }));

      List<Map<String, dynamic>> membersMapList =
          membersList.map((member) => member.toMap()).toList();

      await _firestore.collection('groups').doc(groupId).update(
          {'members': membersMapList, 'totalMembers': membersList.length});

      await _firestore
          .collection('users')
          .doc(userMap.number)
          .collection('groups')
          .doc(groupId)
          .set({
        'name': groupName,
        'id': groupId,
      });
      return true;
    } else {
      return false;
    }
  }

  Future getGroupImage(
      String roomId, MessageModel messages, BuildContext context) async {
    ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadGroupImage(roomId, messages, context);
      }
    });
  }

  Future uploadGroupImage(
      String roomId, MessageModel messages, BuildContext context) async {
    // Add document to Firestore with type 'img' and empty message
    await _firestore
        .collection('groups')
        .doc(roomId)
        .collection('chats')
        .doc(messages.docName)
        .set({
      "sendBy": messages.sendBy,
      "receiveBy": messages.receiveBy,
      "message": '',
      "type": messages.type,
      "status": '0',
      "docName": messages.docName,
      "time": FieldValue.serverTimestamp()
    });

    var ref = FirebaseStorage.instance
        .ref()
        .child('userImages')
        .child('${messages.docName}.jpg');

    try {
      // Try to upload the image
      var uploadTask = await ref.putFile(imageFile!);

      // Get the image URL if upload is successful
      String imageUrl = await uploadTask.ref.getDownloadURL();

      // Update the Firestore document with the image URL
      await _firestore
          .collection('groups')
          .doc(roomId)
          .collection('chats')
          .doc(messages.docName)
          .update({"message": imageUrl});
    } catch (error) {
      status = 0;
      await _firestore
          .collection('groups')
          .doc(roomId)
          .collection('chats')
          .doc(messages.docName)
          .delete();
      reusableSnackBar(context, 'Failed to send image');
    }
  }
  onSendGroupMessage(String roomId, MessageModel messages) async {
    await _firestore
        .collection('groups')
        .doc(roomId)
        .collection('chats')
        .doc(messages.docName)
        .set({
      "sendBy": messages.sendBy,
      "receiveBy": messages.receiveBy,
      "message": messages.message,
      "type": messages.type,
      "status": '0',
      "docName": messages.docName,
      "time": FieldValue.serverTimestamp()
    });
  }

}
