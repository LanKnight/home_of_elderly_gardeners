import 'package:flutter/material.dart';

class MyVideosPage extends StatelessWidget {
  const MyVideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的发布'), backgroundColor: Colors.green),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: const [
          ListTile(
            leading: Icon(Icons.video_library),
            title: Text('暂时没有发布的视频'),
            subtitle: Text('你发布的视频将显示在这里'),
          ),
        ],
      ),
    );
  }
}
