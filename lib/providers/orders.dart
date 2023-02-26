import 'package:flutter/material.dart';
import 'package:shop_app/providers/cartModel.dart';

import '../providers/orderModel.dart';

class Orders with ChangeNotifier {
  List<OrderModel> _items = [];

  List<OrderModel> get items => [..._items];

  void addOrder(List<CartModel> _cardItems, double _total) {
    _items.insert(
      0,
      OrderModel(
        id: DateTime.now().toString(),
        products: _cardItems,
        amount: _total,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
