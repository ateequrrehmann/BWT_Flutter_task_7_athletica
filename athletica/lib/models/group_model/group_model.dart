import 'package:athletica/models/user_data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;

  const GroupModel({
    required this.id,
    required this.name,
  });

  GroupModel copyWith(
      {String? id, String? name, int? totalMembers, List<UserData>? members}) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return GroupModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
    );
  }

  factory GroupModel.fromMap(Map<String, dynamic> data) {
    return GroupModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
    );
  }
}
