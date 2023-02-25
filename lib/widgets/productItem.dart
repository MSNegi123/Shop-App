import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/productModel.dart';
import '../constants/constants.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final _product = Provider.of<ProductModel>(context);
    return
        //Consumer(builder: builder,_product,_child)=> ClipRRect(
        Consumer<ProductModel>(  // Consumer<ProductModel> = Provider.of<ProductModel>(context)
            builder: (ctx, _product, _) => ClipRRect(
                  child: GridTile(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                          Routes.productDetailScreenRoute,
                          arguments: _product.id),
                      child: Image.network(
                        _product.imageUrl,
                        fit: BoxFit.cover,
                        // label: _child,
                      ),
                    ),
                    footer: GridTileBar(
                        backgroundColor: Colors.black87,
                        title: Text(_product.title),
                        leading: IconButton(
                            icon: Icon(_product.isFavourite
                                ? Icons.favorite_border
                                : Icons.favorite),
                            color: Theme.of(context).accentColor,
                            onPressed: _product.toggleFavouriteStatus),
                        trailing: IconButton(
                            icon: Icon(Icons.shopping_cart),
                            color: Theme.of(context).accentColor,
                            onPressed: () {})),
                  ),
                ),
        // child: Text('Helper Text'),
        );
  }
}
