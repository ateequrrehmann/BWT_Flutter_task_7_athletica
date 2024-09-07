import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ArticleService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  onDeleteArticle(String title, String id) async {
    try {
      await FirebaseFirestore.instance.collection(title).doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> uploadImage(File image, String fileName) async {
    try {
      final storageRef = _storage.ref().child('default_images/$fileName');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }


  Future<void> editImage(String field, int? subheadingIndex, Map<String, dynamic> article, String title) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final fileName = pickedFile.name; // Get the file name
      try {
        String newImageUrl = await uploadImage(File(pickedFile.path), fileName);

          if (subheadingIndex == null) {
            article[field] = newImageUrl;
          } else {
            article['subheadings'][subheadingIndex][field] = newImageUrl;
          }
          updateArticle(article,title );

      } catch (e) {

      }
    }

  }
  Future<void> updateArticle(Map<String, dynamic> updatedDetails, String title) async {
    try {
      // Ensure the Firestore document path is correct
      await _firestore.collection(title).doc(updatedDetails['id']).update(updatedDetails);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Article updated successfully')));
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update article: $e')));
    }
  }



}
