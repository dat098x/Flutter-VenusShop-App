import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get item {
    return {..._items};
  }
  int get countItems {
    return _items.length;
  }

  int get countTotalItems {
    int countItems = 0;
    _items.forEach((key, value) {
        countItems += value.quantity;
    });
    return countItems;
  }

  double get totalAmount {
    var totalAmount = 0.0;
    _items.forEach((key, value) {
      totalAmount += value.quantity * value.price;
    });
    return totalAmount;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(productId,() => CartItem(id: DateTime.now().toString(), title: title, price: price, quantity: 1));
    }
    notifyListeners();
  }
}