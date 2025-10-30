import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import 'profile_detail_page.dart';
import 'my_videos_page.dart';
import 'watch_history_page.dart';
import '../../pages/shopping/order_page.dart';
import 'my_shop_page.dart';
import 'settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('我的'), backgroundColor: Colors.green),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('个人资料'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileDetailPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_camera_back),
            title: const Text('我的发布'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MyVideosPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('观看历史'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const WatchHistoryPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('我的订单'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('我的店铺'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MyShopPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('设置'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.support_agent),
            title: const Text('客服'),
            onTap: () {
              // placeholder customer service
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('联系客服（占位）')));
            },
          ),
          SwitchListTile(
            value: theme.isCareVersion,
            title: const Text('关怀版（大字体）'),
            onChanged: (v) => theme.setCareVersion(v),
          ),
        ],
      ),
    );
  }
}
