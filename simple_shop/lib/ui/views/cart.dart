import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_shop/business_logic/view_models/cart_viewmodel.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: Theme.of(context).textTheme.headline1,
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.yellow,
        child: Column(
          children: const [
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(32),
              child: CartList(),
            )),
            Divider(
              height: 4,
              color: Colors.black,
            ),
            CartTotal()
          ],
        ),
      ),
    );
  }
}

class CartList extends StatelessWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.headline6;

    var cart = context.watch<CartViewModel>();

    return ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) => ListTile(
              leading: const Icon(Icons.done),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  cart.remove(cart.items[index]);
                },
              ),
              title: Text(
                cart.items[index].name,
                style: itemNameStyle,
              ),
            ));
  }
}

class CartTotal extends StatelessWidget {
  const CartTotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hugeStyle =
        Theme.of(context).textTheme.headline1!.copyWith(fontSize: 48);

    return SizedBox(
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<CartViewModel>(builder: (context, cartVM, child) {
              return Text(
                '\$${cartVM.totalPrice}',
                style: hugeStyle,
              );
            }),
            const SizedBox(
              width: 24,
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Buying not supported yet.')));
              },
              child: const Text('BUY'),
              style: TextButton.styleFrom(primary: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
