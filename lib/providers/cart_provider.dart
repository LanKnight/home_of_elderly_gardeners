import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  // 获取购物车商品总数
  int get totalCount => _items.length;

  // 计算总价
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.price);
  }

  void add(Product p) {
    _items.add(p);
    notifyListeners();
  }

  void remove(Product p) {
    _items.remove(p);
    notifyListeners();
  }

  // 移除指定商品的所有数量
  void removeAll(Product p) {
    _items.removeWhere((item) => item.id == p.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  // 获取指定商品的数量
  int getQuantity(Product p) {
    return _items.where((item) => item.id == p.id).length;
  }
}
