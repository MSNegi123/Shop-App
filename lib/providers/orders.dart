import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/cartModel.dart';
import '../providers/orderModel.dart';

class Orders with ChangeNotifier {
  List<OrderModel> _items = [];

  List<OrderModel> get items => [..._items];
  final String _userId;

  Orders(this._userId, this._items);

  Future<void> addOrders(List<CartModel> _cardItems, double _total) async {
    final _url = Uri.https(
        'shop-app-de205-default-rtdb.firebaseio.com', '/orders/$_userId.json');
    final _timeStamp = DateTime.now();
    await http.post(
      _url,
      body: json.encode({
        'amount': _total,
        'dateTime': _timeStamp.toIso8601String(),
        'products': _cardItems.map((cp) {
          return {
            'id': cp.id,
            'title': cp.title,
            'price': cp.price,
            'quantity': cp.quantity,
          };
        }).toList(),
      }),
    );
    _items.insert(
      0,
      OrderModel(
        id: _timeStamp.toString(),
        products: _cardItems,
        amount: _total,
        dateTime: _timeStamp,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final _url = Uri.https(
        'shop-app-de205-default-rtdb.firebaseio.com', '/orders/$_userId.json');
    try {
      final _response = await http.get(_url);
      final _fetchedOrders =
          json.decode(_response.body) as Map<String, dynamic>;
      if (_fetchedOrders == null) {
        return;
      }
      final List<OrderModel> _ordersList = [];
      _fetchedOrders.forEach((_id, _order) {
        _ordersList.add(OrderModel(
          id: _id,
          amount: _order['amount'],
          dateTime: DateTime.parse(_order['dateTime']),
          products: (_order['products'] as List<dynamic>)
              .map(
                (order) => CartModel(
                  id: order['id'],
                  title: order['title'],
                  price: order['price'],
                  quantity: order['quantity'],
                ),
              )
              .toList(),
        ));
      });
      _items = _ordersList.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
