import 'dart:typed_data';

import 'package:athletica/views/widgets/reusable_snack_bar/reusable_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  final usersCollection = FirebaseFirestore.instance.collection('users');

  Future<Uint8List?> pickImage(ImageSource source, BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();
    var file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    reusableSnackBar(context, 'No image selected');
    return null;
  }

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref =
        FirebaseStorage.instance.ref().child(childName).child('ProfilePhoto');
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> updateUserProfileImage(Uint8List file, String number) async {
    String imageUrl = await uploadImageToStorage(number, file);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(number)
        .update({'imageUrl': imageUrl});
  }

  Future<void> updateUserName(String number, String newName) async {
    await usersCollection.doc(number).update({'userName': newName});
  }

  Future<void> updateUserBio(String number, String newBio) async {
    await usersCollection.doc(number).update({'bio': newBio});
  }

  Future<void> updateUserEmail(String number, String newEmail) async {
    await usersCollection.doc(number).update({'email': newEmail});
  }

}

