import 'package:flutter/material.dart';
import 'cyber_tree_page.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('社区'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('用户分享'),
            subtitle: const Text('查看社区用户的园艺分享'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('进入用户分享（占位）')));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('提问与答疑'),
            subtitle: const Text('向社区提问或查看问题'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('进入提问（占位）')));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.grass),
            title: const Text('赛博种树'),
            subtitle: const Text('一个趣味的虚拟种树小游戏'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CyberTreePage()));
            },
          ),
        ],
      ),
    );
  }
}
