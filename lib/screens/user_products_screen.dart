import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/appBarDrawer.dart';
import '../constants/constants.dart';
import '../widgets/userProductItem.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      drawer: AppBarDrawer(),
      body: FutureBuilder(
        future: _pullToRefresh(context),
        builder: (ctx, snapshotData) =>
            snapshotData.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _pullToRefresh(context),
                    child: Consumer<Products>(
                      builder: (ctx, product, _) => ListView.builder(
                        itemCount: product.products.length,
                        itemBuilder: (_, index) => UserProductItem(
                            product.products[index].id,
                            product.products[index].title,
                            product.products[index].imageUrl),
                      ),
                    ),
                  ),
      ),
    );
  }

  Future<void> _pullToRefresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }
}
