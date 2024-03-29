import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  const CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity,
      @required this.productId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      confirmDismiss: (dismissDirection) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Do you want to delete item from cart?"),
          actions: [
            FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("No")),
            FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Yes")),
          ],
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                child: Text('₹ $price'),
              ),
            ),
          ),
          title: Text('$title'),
          subtitle: Text('Total: ₹${price * quantity}'),
          trailing: Text('X $quantity'),
        ),
      ),
      onDismissed: (dismissDirection) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
    );
  }
}
