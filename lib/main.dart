import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:venusshop/providers/auth.dart';
import 'package:venusshop/providers/cart.dart';
import 'package:venusshop/providers/orders.dart';
import 'package:venusshop/providers/products.dart';
import 'package:venusshop/screens/splash_screen.dart';
import 'package:venusshop/screens/auth_screen.dart';
import 'package:venusshop/screens/cart_screen.dart';
import 'package:venusshop/screens/edit_product_screen.dart';
import 'package:venusshop/screens/orders_screen.dart';
import 'package:venusshop/screens/product_detail_screen.dart';
import 'package:venusshop/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:venusshop/screens/user_products_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: null,
            update: (context, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items)
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: null,
            update: (context, auth, previousOrders) => Orders(
                auth.token,
                auth.userId,
                previousOrders == null ? [] : previousOrders.orders)
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Vennus Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.orangeAccent,
            fontFamily: 'Lato',

          ),
          home: auth.isAuth()
              ? ProductsOverviewScreen()
              : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, authResultSnapshot) =>
                authResultSnapshot.connectionState ==
                    ConnectionState.waiting
                    ? SplashScreen()
                    : AuthScreen(),
              ),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}

