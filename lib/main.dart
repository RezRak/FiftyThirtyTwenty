import 'package:flutter/material.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
  
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          ],
        ),
      ),
 
    );
  }
}


void updateIncome() {

}

void _insertEssentials(String Name, double Amount) async {
    // Row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: Name,
      DatabaseHelper.columnAmount: Amount,
    };
    final id = await dbHelper.insertEssential(row);
    debugPrint('Inserted row id: $id');
  }


void _insertWants(String Name, double Amount) async {
    // Row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: Name,
      DatabaseHelper.columnAmount: Amount,
    };
    final id = await dbHelper.insertWants(row);
    debugPrint('Inserted row id: $id');
  }



void _insertSavings(String Name, double Amount) async {
    // Row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: Name,
      DatabaseHelper.columnAmount: Amount,
    };
    final id = await dbHelper.insertSavings(row);
    debugPrint('Inserted row id: $id');
  }

void removeExpense(int id) async {
  final rowsDeleted = await dbHelper.deleteEssential(id);
  debugPrint('Deleted $rowsDeleted row(s): row $id');
}

void removeWants(int id) async {
  final rowsDeleted = await dbHelper.deleteWants(id);
  debugPrint('Deleted $rowsDeleted row(s): row $id');
}


void removeSavings(int id) async {
  final rowsDeleted = await dbHelper.deleteSavings(id);
  debugPrint('Deleted $rowsDeleted row(s): row $id');
}