import 'package:flutter/material.dart';

import './cartModel.dart';

class Cart with ChangeNotifier {
  Map<String, CartModel> _items = {};

  Map<String, CartModel> get items {
    return {..._items};
  }

  int get getItemCount{
    return _items.length;
  }

  double get totalAmount {
    double amount = 0.0;
    _items.forEach((key, item) => amount+= item.quantity * item.price);
    return amount;
  }

  void addItemToCart(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingProduct) => CartModel(
            id: existingProduct.id,
            title: existingProduct.title,
            price: existingProduct.price,
            quantity: existingProduct.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartModel(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeItem(String _productId){
    _items.remove(_productId);
    notifyListeners();
  }

  void clearItems(){
    _items.clear();
    notifyListeners();
  }
}
