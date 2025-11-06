import 'package:flutter/material.dart';
import 'package:calorie_tracker/screens/home_add_screen.dart'; // przejscie do dodawacza jedzenia

class HomeScreen extends StatefulWidget { // stateful aby dalo się dodawac pozycje pozniej
  const HomeScreen({super.key}); // konstruktor

  @override
  State<HomeScreen> createState() => HomeScreenState(); // obiekt stanu dla ekranu
}

class HomeScreenState extends State<HomeScreen> { // klasa stanu dla ekranu

  static const int dailyLimit = 2500; // dzienny limit kcal

  // lista map {nazwa posilku, ilosc kalorii w posilku}
  final List<Map<String, dynamic>> meals = [
    {'name': 'dish 1', 'kcal': 300},
    {'name': 'dish 2', 'kcal': 300},
    {'name': 'dish 3', 'kcal': 200},
    {'name': 'dish 4', 'kcal': 600},
    {'name': 'dish 5', 'kcal': 100},
    {'name': 'dish 6', 'kcal': 300},
    {'name': 'dish 7', 'kcal': 100},
    {'name': 'dish 8', 'kcal': 50},
  ];

  void addMeal(String name, int cal) { // funkcja do dodawania posilku
    setState(() {
      meals.add({'name': name, 'kcal': cal}); // dodanie posliku
    }); // po setState lista sama sie odswiezy
  }

  @override
  Widget build(BuildContext context) {
    int sum_kcal = 0; // suma kalorii z listy

    for (final m in meals) {
      int kcal = m['kcal'] as int;
      sum_kcal += kcal; // dodanie kalorii do sumy
    }

    double progress_bar = sum_kcal / dailyLimit; // oblicza jak pasek sie wypelni od 0 - bez wypelnienia do 1 - caly wypelniony

    if (progress_bar > 1.0) {
      progress_bar = 1.0;
    }

    return Scaffold( // szkielet ekranu aby byla lista jako to co jest za guziekiem dodawania

      body: SafeArea( // cialo

        child: Padding(
          padding: const EdgeInsets.all(16), // odstęp 16 pikseli ze wszystkich stron

          child: Column( // ustawienie pionowe jeden pod drugim
            crossAxisAlignment: CrossAxisAlignment.start, // rozciagniecie

            children: [
              const Text(
                'Daily Progress',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // pogrubiony zeby bylo widac
              ),

              const SizedBox(height: 10), // przerwa 12 pikseli pion

              LinearProgressIndicator( // pasek postępu
                value: progress_bar, // wypelnienie
                minHeight: 14, // wysokosc paska
                color: Colors.green, // kolor
                backgroundColor: Color(0xFFEAEAEA), // kolor tla
              ),

              const SizedBox(height: 20), // kolejna przerwa

              Row( // wiersz z tekstem i liczba kalorii
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // oba teksty na przeciwnych koncach
                children: [
                  Text(
                    "Today's Meals",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '$sum_kcal / $dailyLimit kcal', // kalorie ile mamy na liscie / limit
                    style: const TextStyle(fontWeight: FontWeight.bold), // pogrubiony zeby bylo widac
                  ),
                ],
              ),

              const SizedBox(height: 10), // kolejna przerwa

              Expanded( // wypelnia reszte miejsca
                child: ListView.builder( // przewijalna lista
                  itemCount: meals.length, // liczba elementow

                  itemBuilder: (context, index) { // buduje pojedynczy kafelek
                    final meal = meals[index]; // pobiera element z listy

                    return Card(
                      color: Colors.greenAccent, // kolor kafelka

                      child: ListTile( // element listy
                        leading: const Icon(Icons.restaurant_menu), // ikonka
                        title: Text(meal['name'] as String), // nazwa dania
                        subtitle: Text('${meal['kcal']} kcal'), // kalorie
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: SizedBox( // kwadratowy guzika
        width: 60, // szerokosc guzika
        height: 60, // dlugosc guzika

        child: FloatingActionButton(
          backgroundColor: Colors.green, // kolor guzika

          shape: RoundedRectangleBorder( // kształt guzika z zaokragleniem
            borderRadius: BorderRadius.circular(12), // jak bardzo zaokraglony guzik bedzie
          ),

          onPressed: () { // jak sie kliknie
            Navigator.push( // idziemy do nowej strony
              context, // aktualny kontekst
              MaterialPageRoute(builder: (context) => const HomeAddScreen()),
            );
          },
          child: const Icon(Icons.add, size: 30, color: Colors.white), // ikona plusa w srodku guzika
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // prawa dolna strona
    );
  }
}
