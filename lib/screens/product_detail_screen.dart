import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:venusshop/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final productLoaded = Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(productLoaded.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(productLoaded.title),
              background: Hero(
                  tag: productId,
                  child: Image.network(productLoaded.imageUrl, fit: BoxFit.cover,)
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: 10,
                ),
                Text('\$${productLoaded.price}',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(productLoaded.description,
                    style: TextStyle(
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 1500,)
              ])
          )
        ],
      ),
    );
  }
}
