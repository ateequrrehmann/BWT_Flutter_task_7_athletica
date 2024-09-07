import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String name;
  final String email;
  final String number;
  final String userId;
  final String gender;
  final String? imageUrl;
  final String? bio;
  final bool? isAdmin;

  const UserData({
    required this.name,
    required this.email,
    required this.number,
    required this.userId,
    required this.gender,
    this.imageUrl,
    this.bio,
    this.isAdmin,
  });

  UserData copyWith({
    String? name,
    String? email,
    String? number,
    String? userId,
    String? gender,
    String? imageUrl,
    String? bio,
    bool? isAdmin
  }) {
    return UserData(
      name: name ?? this.name,
      email: email ?? this.email,
      number: number ?? this.number,
      userId: userId ?? this.userId,
      gender: gender ?? this.gender,
      imageUrl: imageUrl ?? this.imageUrl,
      bio: bio ?? this.bio,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserData(
      name: data['userName'] ?? '',
      email: data['email'] ?? '',
      number: data['phone'] ?? '',
      userId: data['user_id'] ?? '',
      gender: data['gender'] ?? '',
      bio: data['bio'] ?? '',
      imageUrl: data['imageUrl'],
      isAdmin: data['isAdmin'],
    );
  }

  factory UserData.fromMap(Map<String, dynamic> data) {
    return UserData(
      name: data['userName'] ?? '',
      email: data['email'] ?? '',
      number: data['phone'] ?? '',
      userId: data['user_id'] ?? '',
      gender: data['gender'] ?? '',
      bio: data['bio'] ?? '',
      imageUrl: data['imageUrl'],
      isAdmin: data['isAdmin']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': name,
      'email': email,
      'phone': number,
      'user_id': userId,
      'gender': gender,
      'bio': bio,
      'imageUrl': imageUrl,
      'isAdmin': isAdmin,
    };
  }
}
