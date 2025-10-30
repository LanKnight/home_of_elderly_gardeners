// lib/pages/main_page.dart
import 'package:flutter/material.dart';
import '../../pages/video/video_page.dart';
import '../../pages/shopping/shopping_page.dart';
import '../../pages/profile/profile_page.dart';
import '../../pages/learning/learning_page.dart';
import '../../pages/community/community_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const VideoPage(), // 首页：短视频 + 直播
    const ShoppingPage(), // 商场
    const LearningPage(), // 学习中心
    const CommunityPage(), // 社区
    const ProfilePage(), // 我的
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColorDark,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        selectedIconTheme: IconThemeData(size: 26, color: Theme.of(context).primaryColorDark),
        unselectedIconTheme: IconThemeData(size: 22, color: Colors.grey[600]),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: '商场',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '学习',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: '社区',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        elevation: 8,
      ),
    );
  }
}