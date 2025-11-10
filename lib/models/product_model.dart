class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String? imageUrl;
  final String category; // 分类：'工具', '种子', '肥料', '花盆', '其他'
  final bool isSecondHand; // 是否二手
  final String? sellerId; // 商家ID
  final String? sellerName; // 商家名称
  final int stock; // 库存
  final double? originalPrice; // 原价（用于显示折扣）

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl,
    this.category = '其他',
    this.isSecondHand = false,
    this.sellerId,
    this.sellerName,
    this.stock = 0,
    this.originalPrice,
  });

  // 计算总价（用于购物车）
  double getTotalPrice(int quantity) {
    return price * quantity;
  }

  // 是否有折扣
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  // 折扣百分比
  int get discountPercent {
    if (!hasDiscount) return 0;
    return ((originalPrice! - price) / originalPrice! * 100).round();
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'],
      category: json['category'] ?? '其他',
      isSecondHand: json['isSecondHand'] ?? false,
      sellerId: json['sellerId'],
      sellerName: json['sellerName'],
      stock: json['stock'] ?? 0,
      originalPrice: json['originalPrice'] != null ? (json['originalPrice'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isSecondHand': isSecondHand,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'stock': stock,
      'originalPrice': originalPrice,
    };
  }
}
