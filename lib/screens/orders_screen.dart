import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/appBarDrawer.dart';
import '../widgets/orderItem.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _orders = Provider.of<Orders>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppBarDrawer(),
      body: ListView.builder(
        itemBuilder: (_, index) => OrderItem(_orders[index]),
        itemCount: _orders.length,
      ),
    );
  }
}
