import 'package:flutter/foundation.dart';

import '../providers/cartModel.dart';

class OrderModel {
  final String id;
  final List<CartModel> products;
  final double amount;
  final DateTime dateTime;

  OrderModel(
      {@required this.id,
      @required this.products,
      @required this.amount,
      @required this.dateTime});
}
