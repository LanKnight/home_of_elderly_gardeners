import 'package:flutter/material.dart';

class ProfileDetailPage extends StatelessWidget {
  const ProfileDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // For now show simple profile info; later this can be connected to UserProvider
    return Scaffold(
      appBar: AppBar(title: const Text('个人资料'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CircleAvatar(radius: 40, child: Icon(Icons.person, size: 48)),
            SizedBox(height: 12),
            Text('用户名: 访客', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('邮箱: 未设置'),
            SizedBox(height: 8),
            Text('用户类型: 普通用户'),
          ],
        ),
      ),
    );
  }
}
