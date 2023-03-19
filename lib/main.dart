import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/orders_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './screens/products_overview_screen.dart';
import './constants/constants.dart';
import './screens/product_detail_screen.dart';
import './helpers/custom_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) =>
              Products(auth.userId, previousProducts?.products ?? []),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (_, auth, previousOrders) =>
              Orders(auth.userId, previousOrders?.items ?? []),
        ),
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrangeAccent,
          fontFamily: 'Lato',
          pageTransitionsTheme:PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
            }
          ),
        ),
        home: Consumer<Auth>(
          builder: (_, _auth, _child) => _auth.isAuthenticated
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: _auth.tryAutoLogin(),
                  builder: (_, authSnapshotData) =>
                      authSnapshotData.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
        ),
        routes: {
          Routes.productDetailScreenRoute: (ctx) => ProductDetailScreen(),
          Routes.cartScreenRoute: (ctx) => CartScreen(),
          Routes.ordersScreenRoute: (ctx) => OrdersScreen(),
          Routes.manageProductsScreenRoute: (ctx) => UserProductsScreen(),
          Routes.addProductScreenRoute: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
