import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/productItem.dart';

class ProductsOverviewScreen extends StatelessWidget {
  final _products = DUMMY_PRODUCTS_LIST;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 2,
          crossAxisCount: 2),
      itemBuilder: (ctx, i) =>
          ProductItem(_products[i].title, _products[i].imageUrl),
      itemCount: _products.length,
    );
  }
}
