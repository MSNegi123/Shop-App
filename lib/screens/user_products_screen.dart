import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/userProductItem.dart';

import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: (){}),
        ],
      ),
      body: ListView.builder(
        itemCount: productsData.length,
        itemBuilder: (_, index) => UserProductItem(
            productsData[index].title, productsData[index].imageUrl),
      ),
    );
  }
}
