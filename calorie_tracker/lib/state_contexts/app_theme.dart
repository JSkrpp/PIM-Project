import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppThemeController extends ChangeNotifier { // app theme controller, holds the state
  ThemeMode _mode = ThemeMode.system; // default at system theme
  ThemeMode get mode => _mode;
  
  StreamSubscription? _subscription;
  String? _uid;

  void setMode(ThemeMode mode) { // setter for app theme
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners(); // sends an information about changes to every widget using this class
    
    // Sync with Firestore
    if (_uid != null) {
      String modeStr;
      switch (mode) {
        case ThemeMode.light: modeStr = 'light'; break;
        case ThemeMode.dark: modeStr = 'dark'; break;
        default: modeStr = 'system';
      }
      FirebaseFirestore.instance.collection('users').doc(_uid).set({
        'themeMode': modeStr,
      }, SetOptions(merge: true));
    }
  }

  void connectToFirestore(String uid) {
    _uid = uid;
    _subscription?.cancel();
    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('themeMode')) {
          final modeStr = data['themeMode'] as String;
          ThemeMode newMode;
          switch (modeStr) {
            case 'light': newMode = ThemeMode.light; break;
            case 'dark': newMode = ThemeMode.dark; break;
            default: newMode = ThemeMode.system;
          }
          
          if (newMode != _mode) {
            _mode = newMode;
            notifyListeners();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class AppThemeProvider extends InheritedNotifier<AppThemeController> { // global theme provider, InheritedNotifier auto rebuilds every widget sent
  const AppThemeProvider({super.key, required AppThemeController notifier, required Widget child}) //constructor
      : super(notifier: notifier, child: child);

  static AppThemeController of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppThemeProvider>(); // get provider from widget tree
    assert(provider != null, 'No AppThemeProvider found in context'); // ensure provider exists
    return provider!.notifier!; // return the controller instance
  }
}
