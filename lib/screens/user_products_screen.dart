import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venusshop/providers/products_data.dart';
import 'package:venusshop/screens/edit_product_screen.dart';
import 'package:venusshop/widgets/app_drawer.dart';
import 'package:venusshop/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user-products';
  
  Future<void> _refreshProduct(BuildContext context) async {
    print('Here');
    await Provider.of<ProductsData>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsData>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProduct(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (context, index) => Column(
                children: [
                  UserProductItem(
                    id: productsData.items[index].id,
                    title: productsData.items[index].title,
                    imageUrl: productsData.items[index].imageUrl,
                  ),
                  Divider()
                ],
              ))
        ),
      ),
    );
  }
}
