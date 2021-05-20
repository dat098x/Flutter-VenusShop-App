import 'package:flutter/material.dart';
import 'package:venusshop/providers/cart.dart';
import 'package:venusshop/screens/cart_screen.dart';
import 'package:venusshop/widgets/badget.dart';
import 'package:venusshop/widgets/products_grip.dart';
import 'package:provider/provider.dart';

enum FiltersOption {
  Favorite,
  All
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Venes Shop'),
        actions: [
          PopupMenuButton(
              onSelected: (FiltersOption selectedValue) {
               setState(() {
                 if (selectedValue == FiltersOption.Favorite) {
                   showFavoriteOnly = true;
                 } else {
                   showFavoriteOnly = false;
                 }
               });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(child: Text('Only Favorite'), value: FiltersOption.Favorite),
                PopupMenuItem(child: Text('Show all'), value: FiltersOption.All),
              ]),
          Consumer<Cart>(
            builder: (_,cart,ch) => Badge(
              child: ch,
              value: cart.countTotalItems.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: ProductsGrid(showFavoriteOnly),
    );
  }
}

