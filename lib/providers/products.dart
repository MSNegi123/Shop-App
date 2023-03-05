import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import './productModel.dart';

class Products with ChangeNotifier {
  var _products = [
    // ProductModel(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // ProductModel(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // ProductModel(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // ProductModel(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<ProductModel> get products => [..._products];

  List<ProductModel> get favouriteProducts {
    return _products.where((product) => product.isFavourite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final _url = Uri.https(
        'shop-app-de205-default-rtdb.firebaseio.com', '/products.json');
    try {
      final _response = await http.get(_url);
      final _fetchedProducts =
          json.decode(_response.body) as Map<String, dynamic>;
      if(_fetchedProducts==null){
        return;
      }
      final List<ProductModel> _productList = [];
      _fetchedProducts.forEach((_id, _product) {
        _productList.add(ProductModel(
            id: _id,
            title: _product['title'],
            description: _product['description'],
            imageUrl: _product['imageUrl'],
            price: _product['price'],
            isFavourite: _product['isFavourite']));
      });
      _products = _productList;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(ProductModel _newProduct) async {
    final _url = Uri.https(
        'shop-app-de205-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.post(
        _url,
        body: json.encode({
          'title': _newProduct.title,
          'description': _newProduct.description,
          'imageUrl': _newProduct.imageUrl,
          'price': _newProduct.price,
          'isFavourite': _newProduct.isFavourite,
        }),
      );
      _products.add(ProductModel(
        id: json.decode(response.body)['name'],
        title: _newProduct.title,
        description: _newProduct.description,
        imageUrl: _newProduct.imageUrl,
        price: _newProduct.price,
        isFavourite: _newProduct.isFavourite,
      ));
      notifyListeners();
    } catch (error) {
      print("Error: $error");
      throw error;
    }
  }

  Future<void> updateProduct(
      String _productId, ProductModel _updatedProduct) async {
    var _productIndex =
        _products.indexWhere((product) => product.id == _productId);
    if (_productIndex >= 0) {
      final _url = Uri.https('shop-app-de205-default-rtdb.firebaseio.com',
          '/products/$_productId.json');
      await http.patch(
        _url,
        body: json.encode({
          'title': _updatedProduct.title,
          'description': _updatedProduct.description,
          'imageUrl': _updatedProduct.imageUrl,
          'price': _updatedProduct.price,
        }),
      );
      _products[_productIndex] = _updatedProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String _productId) async {
    var _productIndex =
        _products.indexWhere((product) => product.id == _productId);
    var _existingProduct = _products[_productIndex];
    final _url = Uri.https('shop-app-de205-default-rtdb.firebaseio.com',
        '/products/$_productId.json');

    _products.removeAt(_productIndex);
    notifyListeners();

    final _response = await http.delete(_url);
    if (_response.statusCode >= 400) {
      _products.insert(_productIndex, _existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    _existingProduct = null;
  }

  ProductModel findProductById(String _productId) {
    return _products.firstWhere((product) => product.id == _productId);
  }
}
