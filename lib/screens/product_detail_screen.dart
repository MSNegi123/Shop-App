import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _productId = ModalRoute.of(context).settings.arguments;
    final _product = Provider.of<Products>(context, listen: false)
        .findProductById(_productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(_product.title),
      ),
    );
  }
}
