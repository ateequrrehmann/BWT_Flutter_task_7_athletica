import 'package:athletica/models/user_data/user_data.dart';
import 'package:athletica/services/home_service/home_service.dart';
import 'package:athletica/views/home_screen/widget/item_card.dart';
import 'package:athletica/views/links/image_link/image_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../provider/future_provider/profile_screen_provider/profile_screen_provider.dart';
import '../article/article_screen/article_screen.dart';
import '../calendar/calendar.dart';
import '../color/colors.dart';
import '../widgets/custom_drawer/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String selectedTile = 'HOME';
  final HomeService _homeService = HomeService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _homeService.initializeData(true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _homeService.initializeData(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        _homeService.initializeData(false);
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30.w,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ArticlesScreen(title: 'exercises')),
                    );
                  },
                  child: ItemCard(
                    title: 'Exercise',
                    icon: Icons.fitness_center,
                    width: 42.w,
                    height: 110.0,
                    leftPadding: 5.5.w,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ArticlesScreen(title: 'diet')),
                    );
                  },
                  child: ItemCard(
                    title: 'Diet & Nutrition',
                    icon: Icons.restaurant,
                    width: 42.w,
                    height: 15.h,
                    rightPadding: 5.5.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.5.h),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CalendarScreen()),
                );
              },
              child: ItemCard(
                title: 'Calendar',
                icon: Icons.calendar_today,
                width: 90.w,
                height: 15.h,
                leftPadding: 5.5.w,
                rightPadding: 5.5.w,
              ),
            ),
            SizedBox(height: 3.5.h),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ArticlesScreen(title: 'article')),
                );
              },
              child: ItemCard(
                title: 'Articles',
                icon: Icons.article,
                width: 90.w,
                height: 15.h,
                leftPadding: 5.5.w,
                rightPadding: 5.5.w,
              ),
            ),
          ],
        ),
      ),
      drawer: Consumer(builder: (context, ref, child) {
        final data = ref.watch(userFirebaseProvider);
        return data.when(
          data: (userData) {
            return CustomDrawer(
                selectedTile: selectedTile,
                onItemSelected: (String selected) {
                  selectedTile = selected;
                },
                user: userData);
          },
          loading: () {
            return CustomDrawer(
                selectedTile: selectedTile,
                onItemSelected: (String selected) {
                  selectedTile = selected;
                },
                user: const UserData(
                    name: '', email: '', number: '', userId: '', gender: '', imageUrl: image));
          },
          error: (err, stack) =>
              Center(child: Text('Error loading user data $err')),
        );
      }),
    );
  }
}
