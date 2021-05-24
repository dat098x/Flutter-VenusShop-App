import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venusshop/providers/cart.dart' show Cart;
import 'package:venusshop/providers/orders.dart';
import 'package:venusshop/screens/orders_screen.dart';
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
                  Chip(label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryTextTheme.headline6.color
                    ),
                  ),
                    backgroundColor: Theme.of(context).primaryColor,),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(child: ListView.builder(
              itemCount: cart.countItems,
              itemBuilder: (context, index) {
                return CartItem(
                  id: cart.items.values.toList()[index].id,
                  productId: cart.items.keys.toList()[index],
                  title: cart.items.values.toList()[index].title,
                  quantity: cart.items.values.toList()[index].quantity,
                  price: cart.items.values.toList()[index].price
                );
              }
            )
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoanding = false;
  bool isEnable() {
    if (widget.cart.countItems  <= 0 || _isLoanding) {
      return false;
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoanding ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: !isEnable()
          ? null
          : () async {
        setState(() {
          _isLoanding = true;
        });
        await Provider.of<Orders>(context, listen: false).addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
        setState(() {
          _isLoanding = false;
        });
        widget.cart.clear();
        //Navigator.of(context).pushNamed(OrdersScreen.routeName);
      },
      style: ButtonStyle(
        foregroundColor: isEnable()
            ? MaterialStateProperty.all(Theme.of(context).primaryColor)
            : MaterialStateProperty.all(Theme.of(context).disabledColor)
      ),
    );
  }
}
