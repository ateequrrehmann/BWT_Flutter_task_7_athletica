
import 'package:athletica_admin/provider/future_provider/user_provider/user_provider.dart';
import 'package:athletica_admin/views/widgets/reusable_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../detail_screen/detail_screen.dart';


class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      setState(() {
        users.removeWhere((user) => user['id'] == userId);
      });

      reusableSnackBar(context, 'User deleted successfully');
    } catch (e) {
      reusableSnackBar(context, 'Failed to delete user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: Consumer(builder: (context, ref, child){
        final data=ref.watch(userProvider);
        return data.when(data: (users){
          return ListView.builder(itemBuilder: (context, index){
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailsScreen(user: users[index]),
                  ),
                );
              },
              title: Text(users[index].name ),
              subtitle: Text(users[index].number ),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'delete') {
                    deleteUser(users[index].userId);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            );

          }, itemCount: users.length,);
        }, loading: () =>
        const Center(child: CircularProgressIndicator()),
          error: (error, stack) {
            return Center(child: Text('Error: $error'));
          },);
      }),
    );
  }
}
