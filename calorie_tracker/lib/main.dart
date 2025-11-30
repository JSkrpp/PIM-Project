import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'state_contexts/calorie_goal.dart';
import 'state_contexts/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/food_screen.dart';
import 'state_contexts/food_catalog.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().user,
          initialData: null,
        ),
      ],
      child: const AuthStreamHandler(),
    );
  }
}

class AuthStreamHandler extends StatelessWidget {
  const AuthStreamHandler({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      );
    }
    return AuthWrapper(key: ValueKey(user.uid), user: user);
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key, required this.user});
  final User user;

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late CalorieGoal _goal;
  late FoodCatalog _catalog;
  late AppThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _goal = CalorieGoal(2500);
    _goal.connectToFirestore(widget.user.uid);
    
    _catalog = FoodCatalog([
      Food(name: 'Ryż biały 100g', kcalPer100g: 130),
      Food(name: 'Jajko 50g', kcalPer100g: 78),
      Food(name: 'Kurczak pieczony 200g', kcalPer100g: 476),
      Food(name: 'Brokuły 150g', kcalPer100g: 48),
      Food(name: 'Marchew 100g', kcalPer100g: 41),
    ]);
    _catalog.connectToFirestore(widget.user.uid);
    _themeController = AppThemeController();
    _themeController.connectToFirestore(widget.user.uid);
  }

  @override
  void dispose() {
    _goal.dispose();
    _catalog.dispose();
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeProvider(
      notifier: _themeController,
      child: CalorieGoalProvider(
        notifier: _goal,
        child: FoodCatalogProvider(
          notifier: _catalog,
          child: const MyApp(),
        ),
      ),
    );
  }
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
        home: const BottomNav(),
      ),
    );
  }
}

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
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
            _selectedIndex = index; // update current index
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [ // labels and corresponding destinations
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
