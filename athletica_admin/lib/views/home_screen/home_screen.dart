import 'package:athletica_admin/views/home_screen/widget/feature_card.dart';
import 'package:athletica_admin/views/registered_user/registered_user_screen/registered_user_screen.dart';
import 'package:flutter/material.dart';

import '../article/article_screen/article_screen.dart';
import '../chat/group_chat/group_chat_screen/group_chat_screen.dart';
import '../chat/one_to_one_chat/chat_screen/chat_screen.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          FeatureCard(
              title: 'Articles',
              icon: Icons.article,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>const ArticlesScreen(title: 'article',)))
          ),
          FeatureCard(
              title: 'Exercises',
              icon: Icons.fitness_center,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>const ArticlesScreen(title: 'exercises',)))
          ),
          FeatureCard(
              title: 'Diet & Nutrients',
              icon: Icons.restaurant,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>const ArticlesScreen(title: 'diet',)))
          ),
          FeatureCard(
              title: 'Group Chat',
              icon: Icons.group,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>const GroupChatScreen()))
          ),
          FeatureCard(
              title: 'Users',
              icon: Icons.person,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>const UserListScreen()))
          ),
          FeatureCard(
              title: 'One-to-One Chat',
              icon: Icons.chat,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>const ChatHomeScreen()))
          ),
        ],
      ),
    );
  }
}


