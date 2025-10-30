import 'package:flutter/material.dart';

class MyShopPage extends StatelessWidget {
  const MyShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的店铺'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('店铺名称: 暂未创建', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('创建/管理店铺（占位）')));
              },
              child: const Text('创建/管理店铺'),
            ),
            const SizedBox(height: 12),
            const Expanded(child: Center(child: Text('店铺商品与销售数据将在这里显示（占位）'))),
          ],
        ),
      ),
    );
  }
}
