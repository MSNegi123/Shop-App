import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './productModel.dart';

class Products with ChangeNotifier {
  var _products = [
    ProductModel(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    ProductModel(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    ProductModel(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    ProductModel(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<ProductModel> get products => [..._products];

  List<ProductModel> get favouriteProducts {
    return _products.where((product) => product.isFavourite).toList();
  }

  Future<void> addProduct(ProductModel _newProduct) {
    final _url = Uri.https(
        'shop-app-de205-default-rtdb.firebaseio.com', '/products');
    return http.post(
      _url,
      body: json.encode({
        'title': _newProduct.title,
        'description': _newProduct.description,
        'imageUrl': _newProduct.imageUrl,
        'price': _newProduct.price,
        'isFavourite': _newProduct.isFavourite,
      }),
    ).then((response) {
      _products.add(ProductModel(
        id: json.decode(response.body)['name'],
        title: _newProduct.title,
        description: _newProduct.description,
        imageUrl: _newProduct.imageUrl,
        price: _newProduct.price,
        isFavourite: _newProduct.isFavourite,
      ));
      notifyListeners();
    }).catchError((error){
      print("$error");
      throw error;
    });
  }

  void updateProduct(String _productId, ProductModel _updatedProduct) {
    var _productIndex =
        _products.indexWhere((product) => product.id == _productId);
    _products[_productIndex] = _updatedProduct;
    notifyListeners();
  }

  void deleteProduct(String _productId) {
    _products.removeWhere((product) => product.id == _productId);
    notifyListeners();
  }

  ProductModel findProductById(String _productId) {
    return _products.firstWhere((product) => product.id == _productId);
  }
}
