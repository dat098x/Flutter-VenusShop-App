import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:venusshop/models/http_exception.dart';
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

  Map<String, CartItem> get items {
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
    if (_items.isEmpty) return 0.0;

    var totalAmount = 0.0;
    _items.forEach((key, value) {
      totalAmount += value.quantity * value.price;
    });
    return totalAmount;
  }

  Future<void> fecthAndSetCart() async{
    try {
      final url = Uri.parse('https://venus-shop-5da71-default-rtdb.asia-southeast1.firebasedatabase.app/cart.json');
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String,dynamic>;
      if (extractedData == null) return;
      extractedData.forEach((key, cartData) {
        _items.putIfAbsent(cartData['id'], () => CartItem(
            id: key,
            title: cartData['title'],
            price: cartData['price'],
            quantity: cartData['quantity']));
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }

  }

  Future<void> addItem(String productId, double price, String title) async{
    try {
      if (!_items.containsKey(productId)) {
        final url = Uri.parse('https://venus-shop-5da71-default-rtdb.asia-southeast1.firebasedatabase.app/cart.json');
        final response = await http.post(url, body: jsonEncode({
          'id': productId,
          'title': title,
          'price': price,
          'quantity': 1
        }));
        _items.putIfAbsent(productId,() => CartItem(id: jsonDecode(response.body)['name'], title: title, price: price, quantity: 1));
      } else {
        increaseItem(productId);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeItem(String productId) async {
    final idCart = _items[productId].id;
    final url = Uri.parse('https://venus-shop-5da71-default-rtdb.asia-southeast1.firebasedatabase.app/cart/${idCart}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      throw HttpException('Could not delete cart.');
    } else {
      _items.remove(productId);
      notifyListeners();
    }

  }
  void removeSingleItem(String productId) async {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      final idCart = _items[productId].id;
      final url = Uri.parse('https://venus-shop-5da71-default-rtdb.asia-southeast1.firebasedatabase.app/cart/${idCart}.json');
      await http.patch(url, body: jsonEncode({
        'quantity': _items[productId].quantity - 1
      }));
      _items.update(productId, (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          price: existing.price,
          quantity: existing.quantity - 1));
    } else {
      removeItem(productId);
    }
    notifyListeners();
  }

  Future<void> increaseItem(String productId) async {
    if (!_items.containsKey(productId)) {
      return;
    }
    final idCart = _items[productId].id;
    final url = Uri.parse('https://venus-shop-5da71-default-rtdb.asia-southeast1.firebasedatabase.app/cart/${idCart}.json');
    await http.patch(url, body: jsonEncode({
      'quantity': _items[productId].quantity + 1
    }));
    _items.update(productId, (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quantity: existingCartItem.quantity + 1));
    notifyListeners();
  }


  void clear() {
    final url = Uri.parse('https://venus-shop-5da71-default-rtdb.asia-southeast1.firebasedatabase.app/cart.json');
    http.delete(url);
    _items ={};
    notifyListeners();
  }
}