import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  void add(Product p) {
    _items.add(p);
    notifyListeners();
  }

  void remove(Product p) {
    _items.remove(p);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
