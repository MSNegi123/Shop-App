import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ProductItem extends StatelessWidget {
  final String _title;
  final String _imageUrl;

  const ProductItem(this._title, this._imageUrl);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: GridTile(
        child: GestureDetector(
          onTap: ()=>Navigator.of(context).pushNamed(Routes.productDetailScreenRoute),
          child: Image.network(
            _imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(_title),
            leading: IconButton(
                icon: Icon(Icons.favorite),
                color: Theme.of(context).accentColor,
                onPressed: () {}),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor,
                onPressed: () {})),
      ),
    );
  }
}
