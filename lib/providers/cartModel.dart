import 'package:flutter/foundation.dart';

class CartModel {
  final String id;
  final String title;
  final double price;
  final int quantity;

  const CartModel(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});
}
