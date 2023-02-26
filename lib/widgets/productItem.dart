import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/productModel.dart';
import '../constants/constants.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<ProductModel>(context, listen: false);
    final _cart = Provider.of<Cart>(context, listen: false);
    return
        //Consumer(builder: builder,_product,_child)=> ClipRRect(
        ClipRRect(
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
            leading: Consumer<ProductModel>(
              builder: (ctx, _product, _) => IconButton(
                  icon: Icon(_product.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Theme.of(context).accentColor,
                  onPressed: _product.toggleFavouriteStatus),
            ),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor,
                onPressed: () => _cart.addItemToCart(
                    _product.id, _product.title, _product.price))),
      ),
    );
    // child: Text('Helper Text'),
  }
}
