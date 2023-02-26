import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/productModel.dart';
import '../providers/products.dart';
import '../widgets/productItem.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showFavourites;

  const ProductsGrid(this._showFavourites);

  @override
  Widget build(BuildContext context) {
    var _productsData = Provider.of<Products>(context);
    var _products = _showFavourites
        ? _productsData.favouriteProducts
        : _productsData.products;

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
