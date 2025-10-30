import 'package:flutter/material.dart';
import '../common/search_page.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学习中心'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage()));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                // TODO: 课程购买流程
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('进入课程购买（占位）')));
              },
              child: const Text('购买课程'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                // TODO: 咨询功能
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('进入咨询（占位）')));
              },
              child: const Text('咨询'),
            ),
            const SizedBox(height: 20),
            const Expanded(child: Center(child: Text('课程列表 / 推荐（占位）'))),
          ],
        ),
      ),
    );
  }
}
