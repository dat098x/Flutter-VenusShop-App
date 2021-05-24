import 'package:flutter/material.dart';
import 'package:venusshop/providers/cart.dart';
import 'package:provider/provider.dart';
class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, color: Colors.white, size: 40,),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(context: context,
            builder: (context) => AlertDialog(
              title: Text('Are you sure?',),
              content: Text('Do you want to remove the item from the cart?'),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop(false);
                },
                    child: Text('No')),
                TextButton(onPressed: () {
                  Navigator.of(context).pop(true);
                },
                    child: Text('Yes'))
              ],
            ));
      },
      onDismissed: (direction) async {
        try {
          await Provider.of<Cart>(context, listen: false).removeItem(productId);
        } catch (error) {
          scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Delete Failed', textAlign: TextAlign.center,),
          ));
        }

      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(child: Text('\$${price}')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: FittedBox(
              child: Row(
                children: [
                  IconButton(icon: Icon(Icons.remove), onPressed: () {
                    Provider.of<Cart>(context, listen: false).removeSingleItem(productId);
                  }),
                  SizedBox(width: 4,),
                  Text('$quantity x'),
                  SizedBox(width: 4,),
                  IconButton(icon: Icon(Icons.add), onPressed: () {
                    Provider.of<Cart>(context, listen: false).increaseItem(productId);
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
