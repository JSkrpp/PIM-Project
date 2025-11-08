import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calorie_tracker/state/food_catalog.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});
  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final catalog = FoodCatalogProvider.of(context);
    final items = catalog.items
        .where((f) => f.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Szukaj produktu…',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (q) => setState(() => _query = q),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text('Brak pozycji'))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final f = items[i];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.cookie_outlined),
                            title: Text(f.name),
                            subtitle: Text('${f.kcalPer100g} kcal / 100 g'),
                            onTap: () => _openEditDialog(context, catalog, f),
                            trailing: IconButton(
                              tooltip: 'Usuń',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => catalog.remove(f),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddDialog(context, catalog),
        icon: const Icon(Icons.add),
        label: const Text('Dodaj'),
      ),
    );
  }

  void _openAddDialog(BuildContext context, FoodCatalog catalog) {
    final name = TextEditingController();
    final kcal = TextEditingController();
    final key = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Dodaj produkt'),
        content: Form(
          key: key,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nazwa',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Podaj nazwę' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: kcal,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'kcal / 100 g',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n <= 0) return 'Podaj liczbę > 0';
                return null;
              },
            ),
          ]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          FilledButton(
            onPressed: () {
              if (!(key.currentState?.validate() ?? false)) return;
              catalog.add(Food(
                name: name.text.trim(),
                kcalPer100g: int.parse(kcal.text),
              ));
              Navigator.pop(context);
            },
            child: const Text('Dodaj'),
          ),
        ],
      ),
    );
  }

  void _openEditDialog(BuildContext context, FoodCatalog catalog, Food f) {
    final name = TextEditingController(text: f.name);
    final kcal = TextEditingController(text: f.kcalPer100g.toString());
    final key = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edytuj produkt'),
        content: Form(
          key: key,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nazwa',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Podaj nazwę' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: kcal,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'kcal / 100 g',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n <= 0) return 'Podaj liczbę > 0';
                return null;
              },
            ),
          ]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          FilledButton(
            onPressed: () {
              if (!(key.currentState?.validate() ?? false)) return;
              catalog.update(
                f,
                name: name.text.trim(),
                kcal: int.parse(kcal.text),
              );
              Navigator.pop(context);
            },
            child: const Text('Zapisz'),
          ),
        ],
      ),
    );
  }
}
