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
      borderRadius: BorderRadius.circular(10),
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
            title: Text(
              _product.title,
              textAlign: TextAlign.center,
            ),
            leading: Consumer<ProductModel>(
              builder: (ctx, _product, _) => IconButton(
                  icon: Icon(_product.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Theme.of(context).accentColor,
                  onPressed:()=> _product.toggleFavouriteStatus(_product.id)),
            ),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  _cart.addItemToCart(
                      _product.id, _product.title, _product.price);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('!!Added Item to Cart!!'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () => _cart.removeSingleItem(_product.id),
                      ),
                    ),
                  );
                })),
      ),
    );
    // child: Text('Helper Text'),
  }
}
