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
      // appBar: AppBar(
      //   title: Text(_product.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.33,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_product.title),
              background: Hero(
                tag: _productId,
                child: Image.network(
                  _product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Text(
                  '₹ ${_product.price}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    '${_product.description}',
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(height:800,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
