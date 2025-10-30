import 'package:flutter/material.dart';
import 'order_image_page.dart';

class OrderPage extends StatelessWidget {
	const OrderPage({super.key});

	@override
	Widget build(BuildContext context) {
			return Scaffold(
				appBar: AppBar(
					title: const Text('我的订单'),
					backgroundColor: Colors.green,
					actions: [
						IconButton(
							icon: const Icon(Icons.image),
							tooltip: '欢迎捐款',
							onPressed: () {
								Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderImagePage()));
							},
						),
					],
				),
			body: ListView(
				padding: const EdgeInsets.all(12.0),
				children: const [
					ListTile(
						leading: Icon(Icons.receipt_long),
						title: Text('暂无订单'),
						subtitle: Text('你的订单会显示在这里'),
					),
				],
			),
		);
	}
}
