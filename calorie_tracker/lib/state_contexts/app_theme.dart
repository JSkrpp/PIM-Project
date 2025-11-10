import 'package:flutter/material.dart';

class AppThemeController extends ChangeNotifier { // app theme controller, holds the state
  ThemeMode _mode = ThemeMode.system; // default at system theme
  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) { // setter for app theme
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners(); // sends an information about changes to every widget using this class
  }
}

class AppThemeProvider extends InheritedNotifier<AppThemeController> { // global theme provider, InheritedNotifier auto rebuilds every widget sent
  const AppThemeProvider({super.key, required AppThemeController notifier, required Widget child}) //constructor
      : super(notifier: notifier, child: child);

  static AppThemeController of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppThemeProvider>(); // get provider from widget tree
    assert(provider != null, 'No AppThemeProvider found in context'); // ensure provider exists
    return provider!.notifier!; // return the notifier
  }
}
