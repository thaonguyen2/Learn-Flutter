import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_shop/business_logic/view_models/cart_viewmodel.dart';
import 'package:simple_shop/business_logic/view_models/catalog_viewmodel.dart';
import 'package:simple_shop/common/theme.dart';
import 'package:simple_shop/ui/views/cart.dart';
import 'package:simple_shop/ui/views/catalog.dart';
import 'package:simple_shop/ui/views/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CatalogViewModel()),
        ChangeNotifierProxyProvider<CatalogViewModel, CartViewModel>(
            create: (context) => CartViewModel(),
            update: (context, catalogVM, cartVM) {
              if (cartVM == null) throw ArgumentError.notNull('cart');
              cartVM.catalogViewModel = catalogVM;
              return cartVM;
            })
      ],
      child: MaterialApp(
        title: 'Provider demo',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginView(),
          '/catalog': (context) => const CatalogView(),
          '/cart': (context) => const CartView(),
        },
      ),
    );
  }
}
