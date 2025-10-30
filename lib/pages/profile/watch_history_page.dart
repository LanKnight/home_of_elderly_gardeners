import 'package:flutter/material.dart';

class WatchHistoryPage extends StatelessWidget {
  const WatchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('观看历史'), backgroundColor: Colors.green),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: const [
          ListTile(
            leading: Icon(Icons.history),
            title: Text('暂无观看历史'),
            subtitle: Text('你观看的视频记录会出现在这里'),
          ),
        ],
      ),
    );
  }
}
