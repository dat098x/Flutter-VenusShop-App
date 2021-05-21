import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venusshop/providers/orders.dart' show Orders;
import 'package:venusshop/widgets/app_drawer.dart';
import 'package:venusshop/widgets/order_item.dart';
class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
          itemCount: ordersData.length,
          itemBuilder: (context, index) => OrderItem(ordersData[index])),
    );
  }
}
