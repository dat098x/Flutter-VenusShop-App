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
      appBar: AppBar(
        title: Text(productLoaded.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [Container(
            height: 300,
            width: double.infinity,
            child: Image.network(productLoaded.imageUrl, fit: BoxFit.cover,),
          ),
          SizedBox(
            height: 10,
          ),
            Text('\$${productLoaded.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20
              ),
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
            )
          ]
        ),
      ),
    );
  }
}
