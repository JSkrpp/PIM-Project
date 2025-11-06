import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class CalorieGoal extends ChangeNotifier {
  CalorieGoal(int initialGoal) : _goal = initialGoal;

  int _goal;
  int get goal => _goal;

  void setGoal(int newGoal) {
    if (newGoal == _goal) return;
    _goal = newGoal;
    notifyListeners();
  }
}

class CalorieGoalProvider extends InheritedNotifier<CalorieGoal> {
  const CalorieGoalProvider({super.key, required CalorieGoal notifier, required Widget child})
      : super(notifier: notifier, child: child);

  static CalorieGoal of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<CalorieGoalProvider>();
    assert(provider != null, 'No CalorieGoalProvider found in context');
    return provider!.notifier!;
  }
}
