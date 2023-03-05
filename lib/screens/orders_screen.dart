import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/appBarDrawer.dart';
import '../widgets/orderItem.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final _orders = Provider.of<Orders>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppBarDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.hasError)
              return Text("Error Occured");
            else {
              return Consumer<Orders>(
                builder: (cntx, _orders, _child) => ListView.builder(
                  itemBuilder: (_, index) => OrderItem(_orders.items[index]),
                  itemCount: _orders.items.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
