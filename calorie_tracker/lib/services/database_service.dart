import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // Update user data (calorie goal)
  Future<void> updateUserData(int calorieGoal) async {
    return await userCollection.doc(uid).set({
      'calorieGoal': calorieGoal,
    }, SetOptions(merge: true));
  }

  // Get user doc stream
  Stream<DocumentSnapshot> get userData {
    return userCollection.doc(uid).snapshots();
  }

  // Add food to user's list
  Future<void> addFood(String name, int calories) async {
    await userCollection.doc(uid).collection('foods').add({
      'name': name,
      'calories': calories,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get user's food list stream (Filtered for today)
  Stream<QuerySnapshot> get foods {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    
    return userCollection
        .doc(uid)
        .collection('foods')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfToday))
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
  
  // Delete food
  Future<void> deleteFood(String foodId) async {
    return await userCollection.doc(uid).collection('foods').doc(foodId).delete();
  }
}
