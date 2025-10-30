import 'package:flutter/material.dart';

class OrderImagePage extends StatelessWidget {
  const OrderImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Try to load the image from project assets. Make sure the asset
    // 'assets/icon/QR_code.png' is registered in pubspec.yaml under flutter.assets.
    // If you prefer to load by absolute path, you can replace Image.asset with Image.file.
    const assetPath = 'assets/icon/QR_code.png';

    return Scaffold(
      appBar: AppBar(title: const Text('订单图片'), backgroundColor: Colors.green),
      body: Center(
        child: InteractiveViewer(
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stack) => const Center(child: Text('无法加载本地图片，请确认已在 pubspec.yaml 注册')),
          ),
        ),
      ),
    );
  }
}
