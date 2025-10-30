import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatelessWidget {
	const SettingsPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('设置'), backgroundColor: Colors.green),
			body: ListView(
				children: [
							ListTile(
								leading: const Icon(Icons.support_agent),
								title: const Text('联系客服'),
								onTap: () {
									showDialog(
										context: context,
										builder: (ctx) => AlertDialog(
											title: const Text('联系客服'),
											content: Column(
												mainAxisSize: MainAxisSize.min,
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Row(
														children: [
															const Expanded(child: SelectableText('3264069318@qq.com')),
															IconButton(
																icon: const Icon(Icons.copy),
																onPressed: () {
																	Clipboard.setData(const ClipboardData(text: '3264069318@qq.com'));
																	ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已复制 3264069318@qq.com')));
																},
															)
														],
													),
													const SizedBox(height: 8),
													Row(
														children: [
															const Expanded(child: SelectableText('19216587061@163.com')),
															IconButton(
																icon: const Icon(Icons.copy),
																onPressed: () {
																	Clipboard.setData(const ClipboardData(text: '19216587061@163.com'));
																	ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已复制 19216587061@163.com')));
																},
															)
														],
													),
												],
											),
											actions: [
												TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('关闭')),
											],
										),
									);
								},
							),

					ListTile(
						leading: const Icon(Icons.lock),
						title: const Text('隐私与安全'),
						onTap: () {
							ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('隐私设置（占位）')));
						},
					),
					ListTile(
						leading: const Icon(Icons.notifications),
						title: const Text('通知设置'),
						onTap: () {
							ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('通知设置（占位）')));
						},
					),
					ListTile(
						leading: const Icon(Icons.info),
						title: const Text('关于'),
						onTap: () {
							ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('关于应用（占位）')));
						},
					),
				],
			),
		);
	}
}
