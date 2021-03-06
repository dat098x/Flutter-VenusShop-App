import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venusshop/providers/products.dart';
import 'package:venusshop/screens/edit_product_screen.dart';
import 'package:venusshop/widgets/app_drawer.dart';
import 'package:venusshop/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user-products';
  
  Future<void> _refreshProduct(BuildContext context) async {
    print('Here');
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<ProductsData>(context);
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
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? Center(child: CircularProgressIndicator(),)
            : RefreshIndicator(
          onRefresh: () => _refreshProduct(context),
          child: Consumer<Products>(
            builder: (context, productsData, _ ) => Padding(
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
            )  ,
          ),
        ),
      ),
    );
  }
}
