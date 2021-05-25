import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:venusshop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'package:venusshop/providers/product.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  final String userToken;
  final String userId;
  Orders(this.userToken,this.userId, this._orders);

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse('https://venus-shop-5da71-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$userToken');
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedOrder = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedOrder == null) return;
    extractedOrder.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>).map((p) => CartItem(
              id: p['id'],
              title: p['title'],
              price: p['price'],
              quantity: p['quantity'])).toList(),
          dateTime: DateTime.parse(orderData['dateTime'])
      )
      );
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse('https://venus-shop-5da71-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$userToken');
    final timestamp = DateTime.now();
    final response = await http.post(url, body: jsonEncode({
      'amount': total,
      'dateTime': timestamp.toIso8601String(),
      'products': cartProducts.map((cp) => {
        'id': cp.id,
        'title': cp.title,
        'price': cp.price,
        'quantity': cp.quantity
    }).toList()
    }));
    _orders.insert(0, OrderItem(
        id: jsonDecode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now()));
    notifyListeners();
  }

}