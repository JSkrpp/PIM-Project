import 'package:flutter/material.dart';
import 'package:calorie_tracker/state_contexts/food_catalog.dart';

class HomeAddScreen extends StatefulWidget {
  const HomeAddScreen({super.key});

  @override
  State<HomeAddScreen> createState() => _HomeAddScreenState();
}

class _HomeAddScreenState extends State<HomeAddScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final catalog = FoodCatalogProvider.of(context); // loading catalog from provider
    final allItems = catalog.items;
    
    // Filter items based on search query
    final filteredItems = _searchQuery.isEmpty
        ? allItems
        : allItems.where((food) => food.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Product'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          // Product list
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Text(
                      _searchQuery.isEmpty ? 'No products available' : 'No products found',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    itemCount: filteredItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final food = filteredItems[index];
                      return Card(
                        key: ValueKey('${food.name}_${food.kcalPer100g}_$index'),
                        elevation: 1,
                        child: ListTile(
                          leading: const Icon(Icons.cookie_outlined),
                          title: Text(food.name),
                          subtitle: Text('${food.kcalPer100g} kcal'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.pop(context, { // return selected food data
                              'name': food.name,
                              'cal': food.kcalPer100g,
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}