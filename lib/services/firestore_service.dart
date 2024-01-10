import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference expensesCollection =
      FirebaseFirestore.instance.collection('expenses');

  Future<void> addExpense(Map<String, dynamic> expenseData) async {
    await expensesCollection.add(expenseData);
  }

Future<List<Map<String, dynamic>>> getExpenses() async {
    List<Map<String, dynamic>> expenses = [];
    try {
      QuerySnapshot querySnapshot = await expensesCollection.get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        expenses.add(doc.data() as Map<String, dynamic>);
      }

      return expenses;
    } catch (e) {
      throw('Error getting expenses: $e');
      // return expenses;
    }
  }
}
