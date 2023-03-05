import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../widgets/userProductItem.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Navigator.of(context)
                  .pushNamed(Routes.addProductScreenRoute)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh:()=>_pullToRefresh(context),
        child: ListView.builder(
          itemCount: productsData.length,
          itemBuilder: (_, index) => UserProductItem(
              productsData[index].id,productsData[index].title, productsData[index].imageUrl),
        ),
      ),
    );
  }

  Future<void> _pullToRefresh(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetProducts();
  }
}
