import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final items = cartProvider.items;

    // 计算总价
    double totalPrice = 0;
    final Map<String, int> itemCounts = {};
    for (var item in items) {
      itemCounts[item.id] = (itemCounts[item.id] ?? 0) + 1;
      totalPrice += item.price;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('购物车'),
        backgroundColor: Colors.green,
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('确认清空'),
                    content: const Text('确定要清空购物车吗？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          cartProvider.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('确定'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('清空', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    '购物车是空的',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '快去添加商品吧！',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('去购物'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: itemCounts.length,
                    itemBuilder: (context, index) {
                      final productId = itemCounts.keys.elementAt(index);
                      final product = items.firstWhere((p) => p.id == productId);
                      final count = itemCounts[productId]!;
                      final itemTotal = product.price * count;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: ListTile(
                          leading: product.imageUrl != null
                              ? Image.network(
                                  product.imageUrl!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image),
                                    );
                                  },
                                )
                              : Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image),
                                ),
                          title: Text(product.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('¥${product.price.toStringAsFixed(2)}'),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      cartProvider.remove(product);
                                    },
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      count.toString(),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      cartProvider.add(product);
                                    },
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '¥${itemTotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () {
                                  // 移除该商品的所有数量
                                  for (int i = 0; i < count; i++) {
                                    cartProvider.remove(product);
                                  }
                                },
                                iconSize: 20,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
                // 底部结算栏
                Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '合计：',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            '¥${totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: 跳转到结算页面
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('结算功能开发中...')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '去结算',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

