import 'package:flutter/foundation.dart';
import 'package:simple_shop/business_logic/models/item.dart';
import 'package:simple_shop/business_logic/view_models/catalog_viewmodel.dart';

class CartViewModel extends ChangeNotifier {
  late CatalogViewModel _catalogViewModel;

  final List<int> _itemIds = [];

  CatalogViewModel get catalogViewModel => _catalogViewModel;

  set catalogViewModel(CatalogViewModel newCatalog) {
    _catalogViewModel = newCatalog;
    notifyListeners();
  }

  List<Item> get items =>
      _itemIds.map((id) => _catalogViewModel.getById(id)).toList();

  int get totalPrice => items.fold(0, (total, item) => total + item.price);

  void add(Item item) {
    _itemIds.add(item.id);
    notifyListeners();
  }

  void remove(Item item) {
    _itemIds.remove(item.id);
    notifyListeners();
  }
}
