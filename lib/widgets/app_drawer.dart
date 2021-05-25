import 'package:flutter/material.dart';
import 'package:venusshop/helpers/custom_route.dart';
import 'package:venusshop/providers/auth.dart';
import 'package:venusshop/screens/auth_screen.dart';
import 'package:venusshop/screens/orders_screen.dart';
import 'package:venusshop/screens/products_overview_screen.dart';
import 'package:venusshop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';


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
          Divider(),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Orders'),
            onTap: () => Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Products Manager'),
            onTap: () => Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log out'),
            onTap: () {
              Navigator.of(context).pushReplacement(CustomRoute(
                builder: (context) => AuthScreen(),
              ));
              Provider.of<Auth>(context, listen: false).logout();
            }
          )
        ],
      ),
    );
  }
}
