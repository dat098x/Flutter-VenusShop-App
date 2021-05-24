import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venusshop/providers/orders.dart' show Orders;
import 'package:venusshop/widgets/app_drawer.dart';
import 'package:venusshop/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    //final ordersData = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          print(dataSnapshot.connectionState);
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
