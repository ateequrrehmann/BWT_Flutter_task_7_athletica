import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingInfo{
  final String title;
  final String description;
  final String image;

  OnboardingInfo({required this.title, required this.description, required this.image});

  OnboardingInfo copyWith({
    String? title,
    String? description,
    String? image
  }) {
    return OnboardingInfo(
      title: title?? this.title,
      description: description?? this.description,
      image: image??this.image
    );
  }

  factory OnboardingInfo.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OnboardingInfo(
      title: data['title'],
      description: data['description'],
      image: data['image'],
    );
  }

}