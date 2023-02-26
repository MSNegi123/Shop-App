import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/appBarDrawer.dart';
import '../widgets/badge.dart';
import '../widgets/productsGrid.dart';
import '../constants/constants.dart';

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavourites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (selectedItem) {
              setState(() {
                if (selectedItem == PopUpItems.Favourites) {
                  _showFavourites = true;
                } else {
                  _showFavourites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert_outlined),
            itemBuilder: (ctx) => const [
              PopupMenuItem(
                child: Text('Only Favourites'),
                value: PopUpItems.Favourites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: PopUpItems.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, _child) => Badge(
              child: _child,
              value: cart.getItemCount.toString(),
            ),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.of(context).pushNamed(Routes.cartScreenRoute)),
          ),
        ],
      ),
      drawer: AppBarDrawer(),
      body: ProductsGrid(_showFavourites),
    );
  }
}
