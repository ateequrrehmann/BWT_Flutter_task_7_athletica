import 'package:cloud_firestore/cloud_firestore.dart';

class UserStatusModel {
  final String userName;
  final bool isOnline;

  const UserStatusModel({required this.userName, required this.isOnline});

  UserStatusModel copyWith({String? userName, bool? isOnline}) {
    return UserStatusModel(
        userName: userName ?? this.userName,
        isOnline: isOnline ?? this.isOnline);
  }

  factory UserStatusModel.fromMap(DocumentSnapshot data) {
    return UserStatusModel(
        userName: data['userName'], isOnline: data['isOnline']);
  }
}
