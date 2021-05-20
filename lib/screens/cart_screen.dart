import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venusshop/providers/cart.dart' show Cart;
import 'package:venusshop/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Total', style: TextStyle(fontSize: 20),),
                  Spacer(),
                  Chip(label: Text('\$${cart.totalAmount.toString()}',
                    style: TextStyle(
                      color: Theme.of(context).primaryTextTheme.headline6.color
                    ),
                  ),
                    backgroundColor: Theme.of(context).primaryColor,),
                  TextButton(
                    child: Text('ORDER NOW'),
                    onPressed: () {

                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(child: ListView.builder(
              itemCount: cart.countItems,
              itemBuilder: (context, index) {
                return CartItem(
                  id: cart.item.values.toList()[index].id,
                  title: cart.item.values.toList()[index].title,
                  quantity: cart.item.values.toList()[index].quantity,
                  price: cart.item.values.toList()[index].price
                );
              }
            )
          )
        ],
      ),
    );
  }
}
