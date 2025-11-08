import 'package:flutter/material.dart';

class Food {
  Food({required this.name, required this.kcalPer100g});
  String name;
  int kcalPer100g;
}

class FoodCatalog extends ChangeNotifier {
  final List<Food> _items;
  FoodCatalog([List<Food>? initial]) : _items = List.of(initial ?? []);

  List<Food> get items => List.unmodifiable(_items);

  void add(Food f) {
    _items.add(f);
    notifyListeners();
  }

  void update(Food f, {required String name, required int kcal}) {
    f.name = name;
    f.kcalPer100g = kcal;
    notifyListeners();
  }

  void remove(Food f) {
    _items.remove(f);
    notifyListeners();
  }
}

class FoodCatalogProvider extends InheritedNotifier<FoodCatalog> { // notifier for changes in food catalog
  const FoodCatalogProvider({
    required super.notifier,
    required super.child,
    super.key,
  });

  static FoodCatalog of(BuildContext context) => //context builder
      context.dependOnInheritedWidgetOfExactType<FoodCatalogProvider>()!.notifier!;
}
