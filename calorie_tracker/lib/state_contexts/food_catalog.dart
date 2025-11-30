import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  Food({required this.name, required this.kcalPer100g, this.id});
  String name;
  int kcalPer100g;
  String? id;
}

class FoodCatalog extends ChangeNotifier { // food catalog controller
  final List<Food> _items;
  FoodCatalog([List<Food>? initial]) : _items = List.of(initial ?? []);

  List<Food> get items => List.unmodifiable(_items);
  
  StreamSubscription? _subscription;
  CollectionReference? _collection;

  void connectToFirestore(String uid) {
    _collection = FirebaseFirestore.instance.collection('users').doc(uid).collection('catalog');
    
    _subscription?.cancel();
    _subscription = _collection!.snapshots().listen((snapshot) {
      // If Firestore is empty but we have local initial items, upload them (Seed the DB)
      if (snapshot.docs.isEmpty && _items.isNotEmpty) {
        for (final item in _items) {
           _collection!.add({
             'name': item.name,
             'kcal': item.kcalPer100g,
           });
        }
        return; // Wait for the cloud to echo back the data
      }

      _items.clear();
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        _items.add(Food(
          name: data['name'],
          kcalPer100g: data['kcal'],
          id: doc.id,
        ));
      }
      notifyListeners();
    });
  }

  Future<void> add(Food f) async {
    if (_collection != null) {
      await _collection!.add({
        'name': f.name,
        'kcal': f.kcalPer100g,
      });
    } else {
      _items.add(f);
      notifyListeners();
    }
  }

  Future<void> update(Food f, {required String name, required int kcal}) async {
    if (_collection != null && f.id != null) {
      await _collection!.doc(f.id).update({
        'name': name,
        'kcal': kcal,
      });
    } else {
      f.name = name;
      f.kcalPer100g = kcal;
      notifyListeners();
    }
  }

  Future<void> remove(Food f) async {
    if (_collection != null && f.id != null) {
      await _collection!.doc(f.id).delete();
    } else {
      _items.remove(f);
      notifyListeners();
    }
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
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
