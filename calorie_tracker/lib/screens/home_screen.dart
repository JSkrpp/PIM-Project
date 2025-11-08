import 'package:flutter/material.dart';
import 'package:calorie_tracker/screens/home_add_screen.dart'; // przejscie do dodawacza jedzenia
import 'package:calorie_tracker/state_contexts/calorie_goal.dart';

class HomeScreen extends StatefulWidget { // stateful aby dalo się dodawac pozycje pozniej
  const HomeScreen({super.key}); // konstruktor

  @override
  State<HomeScreen> createState() => HomeScreenState(); // obiekt stanu dla ekranu
}

class HomeScreenState extends State<HomeScreen> { // klasa stanu dla ekranu

  // lista map {nazwa posilku, ilosc kalorii w posilku}
  // TODO przy implementacji backendu utworzenie kontekstu daily progressu i ładowanie z bazy danych
  final List<Map<String, dynamic>> meals = []; // na chwile obecna pusta lista przy startupie

  void addMeal(String name, int cal) { // funkcja do dodawania posilku
    setState(() {
      meals.add({'name': name, 'kcal': cal}); // dodanie posliku
    }); // po setState lista sama sie odswiezy
  }

  @override
  Widget build(BuildContext context) {
    final calorieGoal = CalorieGoalProvider.of(context).goal;
    int sum_kcal = 0;

    for (final m in meals) {
      int kcal = m['kcal'] as int;
      sum_kcal += kcal;
    }

  double progress_bar = calorieGoal == 0 ? 0 : sum_kcal / calorieGoal; // oblicza wypelnienie progress bara

    if (progress_bar > 1.0) {
      progress_bar = 1.0;
    }

    // Wybor koloru paska
    Color barColor;
    if (sum_kcal > calorieGoal) {
      barColor = Colors.red.shade700; // przekroczono limit
    } else if (progress_bar >= 0.8) {
      barColor = Colors.orange.shade800; // 80% lub wiecej
    } else {
      barColor = Colors.green; // ponizej 80%
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
                color: barColor, // kolor zaleznie od progresu
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
                    '$sum_kcal / $calorieGoal kcal', // kalorie ile mamy na liscie / limit
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
                      color: Colors.green, // kolor kafelka

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

      floatingActionButton: SizedBox(
        width: 60,
        height: 60,

        child: FloatingActionButton(
          backgroundColor: Colors.green, // kolor guzika

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          onPressed: () async { // jak sie kliknie
            final result = await Navigator.push( // idziemy do nowej strony i czekamy na wynik
              context,
              MaterialPageRoute(builder: (context) => const HomeAddScreen()),
            );
            
            // Jesli uzytkownik wybral jedzenie, dane z result sa odpowiednio rzutowane i wywolywana jest funkcja addMeal
            if (result != null && result is Map<String, dynamic>) {
              addMeal(result['name'] as String, result['cal'] as int);
            }
          },
          child: const Icon(Icons.add, size: 30, color: Colors.white), // ikona plusa w srodku guzika
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // prawa dolna strona
    );
  }
}
