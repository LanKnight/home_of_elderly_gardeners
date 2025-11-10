import 'package:flutter/material.dart';
import 'cyber_tree_page.dart';
import 'user_share_page.dart';
import 'question_answer_page.dart';

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
          Card(
            child: ListTile(
              leading: const Icon(Icons.share, color: Colors.green),
              title: const Text('用户分享'),
              subtitle: const Text('查看社区用户的园艺分享'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserSharePage()),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.blue),
              title: const Text('提问与答疑'),
              subtitle: const Text('向社区提问或查看问题'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuestionAnswerPage()),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.grass, color: Colors.green),
              title: const Text('赛博种树'),
              subtitle: const Text('一个趣味的虚拟种树小游戏'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CyberTreePage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
