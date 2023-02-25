import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/productItem.dart';
import '../providers/products.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _products = Provider.of<Products>(context).products;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 2,
          crossAxisCount: 2),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // ChangeNotifierProvider(
        // builder: (ctx)=> ProductModel(),
        value: _products[i],
        child: ProductItem(),
      ),
      itemCount: _products.length,
    );
  }
}
