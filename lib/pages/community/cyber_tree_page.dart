import 'package:flutter/material.dart';

class CyberTreePage extends StatefulWidget {
  const CyberTreePage({super.key});

  @override
  State<CyberTreePage> createState() => _CyberTreePageState();
}

class _CyberTreePageState extends State<CyberTreePage> {
  int _level = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('赛博种树'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('你的树等级：$_level', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                setState(() {
                  _level++;
                });
              },
              child: const Text('浇水（升级）'),
            ),
            const SizedBox(height: 8),
            const Text('这是一个简单的占位小游戏，后续可以加入更多互动。'),
          ],
        ),
      ),
    );
  }
}
