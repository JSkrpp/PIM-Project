import 'package:flutter/material.dart';
import 'state_contexts/calorie_goal.dart';
import 'state_contexts/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/food_screen.dart';
import 'state_contexts/food_catalog.dart';
import 'screens/profile_screen.dart';

void main() {


  final goal = CalorieGoal(2500);
  final catalog = FoodCatalog([
    Food(name: 'Ryż biały 100g', kcalPer100g: 130),
    Food(name: 'Jajko 50g', kcalPer100g: 78),
    Food(name: 'Kurczak pieczony 200g', kcalPer100g: 476),
    Food(name: 'Brokuły 150g', kcalPer100g: 48),
    Food(name: 'Marchew 100g', kcalPer100g: 41),
  ]);
  final themeController = AppThemeController();


  runApp(AppThemeProvider(
    notifier: themeController,
    child: CalorieGoalProvider(
      notifier: goal,
      child: FoodCatalogProvider(
        notifier: catalog,
        child: const MyApp(),
      ),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildLight() => ThemeData( // light mode builder
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.light),
        navigationBarTheme: const NavigationBarThemeData(
          indicatorColor: Colors.green,
          backgroundColor: Colors.white,
        ),
      );

  ThemeData _buildDark() => ThemeData( //dark mode builder
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
        navigationBarTheme: const NavigationBarThemeData(
          indicatorColor: Colors.green,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final themeController = AppThemeProvider.of(context);
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Calorie Tracker',
        theme: _buildLight(),
        darkTheme: _buildDark(),
        themeMode: themeController.mode,
        home: const BottomNavM3(),
      ),
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
