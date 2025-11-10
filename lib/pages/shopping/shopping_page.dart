import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import 'product_detail_page.dart';
import 'cart_page.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  String _selectedCategory = '全部';
  bool _showSecondHandOnly = false;

  final List<String> _categories = ['全部', '工具', '种子', '肥料', '花盆', '其他'];

  // 示例商品数据
  final List<Product> _allProducts = [
    Product(
      id: 'p1',
      title: '园艺剪刀套装',
      description: '专业园艺剪刀，适合修剪各种植物，轻便易用',
      price: 45.00,
      originalPrice: 60.00,
      category: '工具',
      stock: 20,
      imageUrl: null,
      sellerName: '园艺工具专营店',
    ),
    Product(
      id: 'p2',
      title: '番茄种子',
      description: '优质番茄种子，发芽率高，适合家庭种植',
      price: 12.50,
      category: '种子',
      stock: 100,
      imageUrl: null,
      sellerName: '种子商城',
    ),
    Product(
      id: 'p3',
      title: '有机肥料',
      description: '天然有机肥料，促进植物生长，环保健康',
      price: 28.00,
      category: '肥料',
      stock: 50,
      imageUrl: null,
      sellerName: '绿色农资',
    ),
    Product(
      id: 'p4',
      title: '陶瓷花盆（二手）',
      description: '使用过的陶瓷花盆，状态良好，价格实惠',
      price: 15.00,
      originalPrice: 30.00,
      category: '花盆',
      isSecondHand: true,
      stock: 5,
      imageUrl: null,
      sellerName: '二手园艺市场',
    ),
    Product(
      id: 'p5',
      title: '浇水壶',
      description: '大容量浇水壶，带喷头，方便浇水',
      price: 35.00,
      category: '工具',
      stock: 30,
      imageUrl: null,
      sellerName: '园艺工具专营店',
    ),
    Product(
      id: 'p6',
      title: '多肉植物种子',
      description: '多种多肉植物种子混合装，适合新手',
      price: 18.00,
      category: '种子',
      stock: 80,
      imageUrl: null,
      sellerName: '种子商城',
    ),
    Product(
      id: 'p7',
      title: '复合肥料',
      description: 'NPK复合肥料，营养全面，促进植物生长',
      price: 42.00,
      category: '肥料',
      stock: 40,
      imageUrl: null,
      sellerName: '绿色农资',
    ),
    Product(
      id: 'p8',
      title: '塑料花盆套装',
      description: '10个装塑料花盆，轻便耐用，适合室内外使用',
      price: 25.00,
      category: '花盆',
      stock: 60,
      imageUrl: null,
      sellerName: '园艺工具专营店',
    ),
  ];

  List<Product> get _filteredProducts {
    var filtered = _allProducts;
    
    // 分类筛选
    if (_selectedCategory != '全部') {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }
    
    // 二手筛选
    if (_showSecondHandOnly) {
      filtered = filtered.where((p) => p.isSecondHand).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final filteredProducts = _filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('购物'),
        backgroundColor: Colors.green,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
              ),
              if (cartProvider.totalCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cartProvider.totalCount > 99 ? '99+' : cartProvider.totalCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 筛选栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey[100],
            child: Column(
              children: [
                // 分类选择
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          selectedColor: Colors.green[300],
                          checkmarkColor: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                // 二手筛选
                Row(
                  children: [
                    Checkbox(
                      value: _showSecondHandOnly,
                      onChanged: (value) {
                        setState(() {
                          _showSecondHandOnly = value ?? false;
                        });
                      },
                    ),
                    const Text('仅显示二手商品'),
                  ],
                ),
              ],
            ),
          ),
          // 商品列表
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          '没有找到商品',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = '全部';
                              _showSecondHandOnly = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('清除筛选'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        elevation: 2,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailPage(product: product),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // 商品图片
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: product.imageUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            product.imageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(Icons.image, color: Colors.grey);
                                            },
                                          ),
                                        )
                                      : const Icon(Icons.image, color: Colors.grey),
                                ),
                                const SizedBox(width: 12),
                                // 商品信息
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              product.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (product.isSecondHand)
                                            Container(
                                              margin: const EdgeInsets.only(left: 4),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                '二手',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product.description,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            '¥${product.price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[700],
                                            ),
                                          ),
                                          if (product.hasDiscount) ...[
                                            const SizedBox(width: 8),
                                            Text(
                                              '¥${product.originalPrice!.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      if (product.sellerName != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          '商家: ${product.sellerName}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                // 加入购物车按钮
                                IconButton(
                                  icon: const Icon(Icons.add_shopping_cart),
                                  color: Colors.green,
                                  onPressed: () {
                                    if (product.stock > 0) {
                                      cartProvider.add(product);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('已加入购物车'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('商品缺货'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
