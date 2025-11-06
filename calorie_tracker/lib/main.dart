import 'package:flutter/material.dart';
import 'state/calorie_goal.dart';
import 'screens/home_screen.dart';
import 'screens/food_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  final goal = CalorieGoal(2500);
  runApp(CalorieGoalProvider(
    notifier: goal,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calorie Tracker',
      theme: ThemeData( // app stylisation
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.green,
          backgroundColor: Colors.white,
        )
      ),
      home: const BottomNavM3(),
    );
  }
}

class BottomNavM3 extends StatefulWidget {
  const BottomNavM3({super.key});

  @override
  State<BottomNavM3> createState() => _BottomNavM3State();
}

class _BottomNavM3State extends State<BottomNavM3> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    FoodScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) { // bottom navBar initialization method
    return Scaffold( // scaffold for navBar + current screen app type
      appBar: AppBar(
        title: const Text('Calorie Tracker'),
        centerTitle: true,
      ),
      body: IndexedStack( // active screen shown here, allows the app to remember app states
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() { // showing currently selected screen
            _selectedIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [ //
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.cookie_outlined),
            selectedIcon: Icon(Icons.cookie),
            label: 'Foods',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
