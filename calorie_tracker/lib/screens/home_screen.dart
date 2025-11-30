import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calorie_tracker/screens/home_add_screen.dart';
import 'package:calorie_tracker/state_contexts/calorie_goal.dart';
import '../services/database_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final db = DatabaseService(uid: user.uid);
    final calorieGoal = CalorieGoalProvider.of(context).goal;

    return StreamBuilder<QuerySnapshot>(
      stream: db.foods,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        int sumKcal = 0;
        final meals = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final kcal = data['calories'] as int;
          sumKcal += kcal;
          return {
            'name': data['name'],
            'kcal': kcal,
            'id': doc.id,
          };
        }).toList();

        double progressBar = calorieGoal == 0 ? 0 : sumKcal / calorieGoal;
        if (progressBar > 1.0) progressBar = 1.0;

        Color barColor;
        if (sumKcal > calorieGoal) {
          barColor = Colors.red.shade700;
        } else if (progressBar >= 0.8) {
          barColor = Colors.orange.shade800;
        } else {
          barColor = Colors.green;
        }

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Progress',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progressBar,
                    minHeight: 14,
                    color: barColor,
                    backgroundColor: const Color(0xFFEAEAEA),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Meals",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '$sumKcal / $calorieGoal kcal',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        final meal = meals[index];
                        return Dismissible(
                          key: Key(meal['id'] as String),
                          onDismissed: (direction) {
                            db.deleteFood(meal['id'] as String);
                          },
                          background: Container(color: Colors.red),
                          child: Card(
                            color: Colors.green,
                            child: ListTile(
                              leading: const Icon(Icons.restaurant_menu),
                              title: Text(meal['name'] as String),
                              subtitle: Text('${meal['kcal']} kcal'),
                            ),
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
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeAddScreen()),
                );

                if (result != null && result is Map<String, dynamic>) {
                  await db.addFood(result['name'] as String, result['cal'] as int);
                }
              },
              child: const Icon(Icons.add, size: 30, color: Colors.white),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
