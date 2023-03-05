import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProductModel with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavourite;

  ProductModel(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      this.isFavourite = false});

  void toggleFavouriteStatus(String _productId) async {
    final _oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final _url = Uri.https('shop-app-de205-default-rtdb.firebaseio.com',
        '/products/$_productId.json');
    try {
      final _response = await http.patch(
        _url,
        body: json.encode({
          'isFavourite': isFavourite,
        }),
      );
      if (_response.statusCode >= 400) {
        _setFavourite(_oldStatus);
      }
    } catch (e) {
      _setFavourite(_oldStatus);
    }
  }

  void _setFavourite(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }
}
