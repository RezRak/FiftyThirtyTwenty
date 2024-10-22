import 'package:flutter/material.dart';
import 'package:ftt/signup.dart';
import 'database.dart';

final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the database
  await dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignUp(),
    );
  }
}

void insertIncome(String amountStr) async {
  int amount = int.parse(amountStr);
  Map<String, dynamic> row = {
    DatabaseHelper.columnAmount: amount,
  };
  final id = await dbHelper.insertIncome(row);
  debugPrint('Inserted income row id: $id');
}

void insertEssentials(String name, String amountStr) async {
  int amount = int.parse(amountStr);
  Map<String, dynamic> row = {
    DatabaseHelper.columnName: name,
    DatabaseHelper.columnAmount: amount,
  };
  final id = await dbHelper.insertEssential(row);
  debugPrint('Inserted essential row id: $id');
}

void insertWants(String name, String amountStr) async {
  int amount = int.parse(amountStr);
  Map<String, dynamic> row = {
    DatabaseHelper.columnName: name,
    DatabaseHelper.columnAmount: amount,
  };
  final id = await dbHelper.insertWants(row);
  debugPrint('Inserted want row id: $id');
}

void insertSavings(String name, String amountStr) async {
  int amount = int.parse(amountStr);
  Map<String, dynamic> row = {
    DatabaseHelper.columnName: name,
    DatabaseHelper.columnAmount: amount,
  };
  final id = await dbHelper.insertSavings(row);
  debugPrint('Inserted saving row id: $id');
}

void removeIncome(int id) async {
  final rowsDeleted = await dbHelper.deleteIncome(id);
  debugPrint('Deleted $rowsDeleted income row(s): row $id');
}

void removeEssential(int id) async {
  final rowsDeleted = await dbHelper.deleteEssential(id);
  debugPrint('Deleted $rowsDeleted essential row(s): row $id');
}

void removeWants(int id) async {
  final rowsDeleted = await dbHelper.deleteWants(id);
  debugPrint('Deleted $rowsDeleted wants row(s): row $id');
}

void removeSavings(int id) async {
  final rowsDeleted = await dbHelper.deleteSavings(id);
  debugPrint('Deleted $rowsDeleted savings row(s): row $id');
}
