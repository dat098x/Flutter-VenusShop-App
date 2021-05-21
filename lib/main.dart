import 'package:flutter/material.dart';
import 'package:venusshop/providers/cart.dart';
import 'package:venusshop/providers/orders.dart';
import 'package:venusshop/providers/products_data.dart';
import 'package:venusshop/screens/cart_screen.dart';
import 'package:venusshop/screens/orders_screen.dart';
import 'package:venusshop/screens/product_detail_screen.dart';
import 'package:venusshop/screens/product_overview_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ProductsData(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.orangeAccent,
          fontFamily: 'Lato',

        ),
        initialRoute: '/',
        routes: {
          '/': (context) => ProductOverviewScreen(),
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrdersScreen.routeName: (context) => OrdersScreen(),
        },
      ),
    );
  }
}

