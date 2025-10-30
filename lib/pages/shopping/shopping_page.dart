import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = List.generate(
      8,
      (i) => Product(
        id: 'p$i',
        title: '园艺商品 ${i + 1}',
        description: '适合老年人的园艺用品',
        price: 9.99 + i,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('购物'), backgroundColor: Colors.green),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(p.title),
              subtitle: Text(p.description),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('加入购物车'),
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).add(p);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已加入购物车')));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
