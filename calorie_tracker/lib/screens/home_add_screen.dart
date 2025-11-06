import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // do klawiatury

class HomeAddScreen extends StatefulWidget {
  const HomeAddScreen({super.key}); // konstruktor

  @override
  State<HomeAddScreen> createState() => HomeAddScreenState(); // stan ekranu
}

class HomeAddScreenState extends State<HomeAddScreen> { // klasa stanu dla ekranu
  final formKey = GlobalKey<FormState>(); // klucz do walidacji
  final nameController = TextEditingController(); // kontroler pola nazwy
  final kcalController = TextEditingController(); // kontroler pola kalorii

  @override
  void dispose() { // sprzatanie
    nameController.dispose(); // zwalnia kontroler nazwy
    kcalController.dispose(); // zwalnia kontroler kalorii
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold( // szkielet ekranu z bialym tlem polami i guzikiem

      appBar: AppBar(
        title: const Text('Add Meal'),
        centerTitle: true, // centrowanie
      ),

      body: Padding(
        padding: const EdgeInsets.all(16), // odstęp 16 pikseli ze wszystkich stron

        child: Form( // formularz
          key: formKey, // klucz formularza

          child: Column( // ustawienie pionowe jeden pod drugim
            crossAxisAlignment: CrossAxisAlignment.stretch, // rozciagniecie

            children: [
              TextFormField( // pole nazwy
                controller: nameController, // kontroler pola nazwy

                textInputAction: TextInputAction.next, // enter przechodzi do kolejnego pola

                decoration: const InputDecoration( // wyglad pola
                  labelText: 'Meal name', // etykieta
                  border: OutlineInputBorder(), // ramka
                ),

                validator: (valid) { // walidacja nazwy
                  if (valid == null || valid.trim().isEmpty) { // sprawdza czy puste
                    return 'enter meal name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField( // pole kalorii
                controller: kcalController, // kontroler kalorii

                keyboardType: TextInputType.number, // klawiatura numeryczna

                inputFormatters: [FilteringTextInputFormatter.digitsOnly], // pozwala wpisać tylko cyfry

                textInputAction: TextInputAction.done, // enter to koniec

                decoration: const InputDecoration(
                  labelText: 'Calories (kcal)', // etykieta
                  border: OutlineInputBorder(), // ramka
                ),

                validator: (valid) { // walidacja kalorii
                  if (valid == null || valid.trim().isEmpty) { // sprawdza czy puste
                    return 'enter calories';
                  }

                  final n = int.tryParse(valid); // praba zmiany na liczbe

                  if (n == null || n <= 0) {
                    return 'enter a number > 0'; // liczba musi być > 0
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              Align(
                alignment: Alignment.center, // centrowanie guzika

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom( // styl guzika
                    backgroundColor: Colors.blue, // kolor tla

                    foregroundColor: Colors.white, // kolor napisu

                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12), // rozmiar guzika

                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // zaokraglenie
                  ),

                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) { // jak walidacja ok
                      final name = nameController.text.trim(); // nazwa

                      final kcal = int.parse(kcalController.text.trim()); // kalorie

                      Navigator.pop(context, {'name': name, 'cal': kcal}); // wraca na poprzedni ekran
                    }
                  },
                  child: const Text('ADD', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // napis guzika pogrubiony
                ),

              ),

            ],
          ),

        ),

      ),

    );

  }
}