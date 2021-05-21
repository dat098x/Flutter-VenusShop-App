import 'package:flutter/material.dart';
import 'package:venusshop/screens/orders_screen.dart';
import 'package:venusshop/screens/user_products_screen.dart';



class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('VENUS SHOP'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Orders'),
            onTap: () => Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName),
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Products Manager'),
            onTap: () => Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName),
          )
        ],
      ),
    );
  }
}
