import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_shop/business_logic/view_models/cart_viewmodel.dart';
import 'package:simple_shop/business_logic/view_models/catalog_viewmodel.dart';

import '../../business_logic/models/item.dart';

class CatalogView extends StatelessWidget {
  const CatalogView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _AppBar(),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 12,
            ),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((context, index) => ListItem(index)),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final Item item;

  const _AddButton({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isInCart = context.select<CartViewModel, bool>(
      (cartVM) => cartVM.items.contains(item),
    );

    return TextButton(
        onPressed: isInCart
            ? null
            : () {
                var cart = context.read<CartViewModel>();
                cart.add(item);
              },
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor;
          }
          return null;
        })),
        child: isInCart
            ? const Icon(
                Icons.check,
                semanticLabel: 'ADDED',
              )
            : const Text('ADD'));
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        'Catalog',
        style: Theme.of(context).textTheme.headline1,
      ),
      floating: true,
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            icon: const Icon(Icons.shopping_cart))
      ],
    );
  }
}

class ListItem extends StatelessWidget {
  final int index;

  const ListItem(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var item = context.select<CatalogViewModel, Item>(
        (catalogVM) => catalogVM.getByPosition(index));
    var textTheme = Theme.of(context).textTheme.headline6;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: item.color,
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Expanded(
                child: Text(
              item.name,
              style: textTheme,
            )),
            const SizedBox(
              width: 24,
            ),
            _AddButton(item: item)
          ],
        ),
      ),
    );
  }
}
