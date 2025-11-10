import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品详情'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 商品图片
            Container(
              height: 300,
              color: Colors.grey[200],
              child: product.imageUrl != null
                  ? Image.network(
                      product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image, size: 100, color: Colors.grey),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(Icons.image, size: 100, color: Colors.grey),
                    ),
            ),
            // 商品信息
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题和标签
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (product.isSecondHand)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '二手',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 价格
                  Row(
                    children: [
                      Text(
                        '¥${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 12),
                        Text(
                          '¥${product.originalPrice!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${product.discountPercent}% OFF',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 分类和商家
                  Wrap(
                    spacing: 12,
                    children: [
                      Chip(
                        label: Text('分类: ${product.category}'),
                        backgroundColor: Colors.green[100],
                      ),
                      if (product.sellerName != null)
                        Chip(
                          label: Text('商家: ${product.sellerName}'),
                          backgroundColor: Colors.blue[100],
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // 商品描述
                  const Text(
                    '商品描述',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  // 库存信息
                  Text(
                    '库存: ${product.stock > 0 ? product.stock.toString() : "缺货"}',
                    style: TextStyle(
                      fontSize: 16,
                      color: product.stock > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: product.stock > 0
                    ? () {
                        Provider.of<CartProvider>(context, listen: false).add(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('已加入购物车'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.shopping_cart),
                label: const Text('加入购物车'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: product.stock > 0
                    ? () {
                        // 直接购买
                        Provider.of<CartProvider>(context, listen: false).add(product);
                        Navigator.pushNamed(context, '/cart');
                      }
                    : null,
                icon: const Icon(Icons.payment),
                label: const Text('立即购买'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

