import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/appBarDrawer.dart';
import '../widgets/orderItem.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  @override
  void initState() {
    _isLoading = true;

    // Future.delayed(Duration.zero).then((value) async {
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then(
      (_) {
        setState(() {
          _isLoading = false;
        });
      },
    );
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _orders = Provider.of<Orders>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppBarDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (_, index) => OrderItem(_orders[index]),
              itemCount: _orders.length,
            ),
    );
  }
}
