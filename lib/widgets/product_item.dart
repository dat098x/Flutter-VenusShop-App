import 'package:flutter/material.dart';
import 'package:venusshop/providers/auth.dart';
import 'package:venusshop/providers/cart.dart';
import 'package:venusshop/providers/product.dart';
import 'package:venusshop/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    final auth = Provider.of<Auth>(context);
    return  ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 5,
          child: GridTile(
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                      ProductDetailScreen.routeName,
                      arguments: product.id
                  );
                },
                child: Hero(
                  tag: product.id,
                  child: FadeInImage(
                      placeholder: AssetImage('assets/images/product-placeholder.png'),
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.cover,
                  ),
                )
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: Consumer<Product>(
                  builder: (ctx, product, index) => IconButton(
                      icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        product.toggleFavoriteStatus(auth.token, auth.userId);
                    },
                  ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor,
                onPressed: () {
                    cart.addItem(product.id, product.price, product.title);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added Item to cart!',textAlign: TextAlign.center,),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            cart.removeSingleItem(product.id);
                          },
                        ),
                      )
                    );
                },
              ),
              title: Text(product.title, textAlign: TextAlign.center,),
            ),
          ),
        ),
      );
  }
}
