import 'package:flutter/material.dart';
import 'package:venusshop/providers/products_data.dart';
import 'package:venusshop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.edit, color: Theme.of(context).primaryColor,),
                onPressed: () {
                    Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id);
                }),
            IconButton(icon: Icon(Icons.delete, color: Theme.of(context).errorColor,),
                onPressed: () async {
                    try {
                      await Provider.of<ProductsData>(context, listen: false).deleteProduct(id);
                    } catch (error) {
                      scaffoldMessenger.showSnackBar(SnackBar(
                          content: Text('Delete Failed', textAlign: TextAlign.center,)));
                    }

                })
          ],
        ),
      ),
    );
  }
}
