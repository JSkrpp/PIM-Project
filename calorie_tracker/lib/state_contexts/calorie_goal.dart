import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalorieGoal extends ChangeNotifier { // calorie goal controller
  CalorieGoal(int initialGoal) : _goal = initialGoal;

  int _goal;
  int get goal => _goal;
  
  StreamSubscription? _subscription;
  String? _uid;

  void setGoal(int newGoal) {
    if (newGoal == _goal) return;
    _goal = newGoal;
    notifyListeners();
    
    // Sync with Firestore if connected
    if (_uid != null) {
      FirebaseFirestore.instance.collection('users').doc(_uid).set({
        'calorieGoal': newGoal,
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
        if (data.containsKey('calorieGoal')) {
          final fetchedGoal = data['calorieGoal'] as int;
          if (fetchedGoal != _goal) {
            _goal = fetchedGoal;
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

class CalorieGoalProvider extends InheritedNotifier<CalorieGoal> { // provider for the calorie goal
  const CalorieGoalProvider({super.key, required CalorieGoal notifier, required Widget child})
      : super(notifier: notifier, child: child);

  static CalorieGoal of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<CalorieGoalProvider>();
    assert(provider != null, 'No CalorieGoalProvider found in context');
    return provider!.notifier!;
  }
}
