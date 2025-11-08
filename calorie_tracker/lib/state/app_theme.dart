import 'package:flutter/material.dart';

class AppThemeController extends ChangeNotifier { // app theme controller
  ThemeMode _mode = ThemeMode.system; // default at system theme
  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) { // setter for app theme
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }
}

class AppThemeProvider extends InheritedNotifier<AppThemeController> { // global theme provider
  const AppThemeProvider({super.key, required AppThemeController notifier, required Widget child})
      : super(notifier: notifier, child: child);

  static AppThemeController of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppThemeProvider>();
    assert(provider != null, 'No AppThemeProvider found in context');
    return provider!.notifier!;
  }
}
