import 'package:flutter/material.dart';
import 'package:ftt/database.dart';
import 'main.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Text controllers for input fields
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController essentialNameController = TextEditingController();
  final TextEditingController essentialAmountController = TextEditingController();
  final TextEditingController wantNameController = TextEditingController();
  final TextEditingController wantAmountController = TextEditingController();
  final TextEditingController savingNameController = TextEditingController();
  final TextEditingController savingAmountController = TextEditingController();

  // Lists to store database entries
  List<Map<String, dynamic>> incomeList = [];
  List<Map<String, dynamic>> essentialsList = [];
  List<Map<String, dynamic>> wantsList = [];
  List<Map<String, dynamic>> savingsList = [];

  // Instance of DatabaseHelper
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    // Initialize database and fetch existing entries
    initDatabase();
  }

  Future<void> initDatabase() async {
    await dbHelper.init();
    await displayIncome();
    await displayEssentials();
    await displayWants();
    await displaySavings();
  }

  void clearText(String state) {
    // Clears text boxes after clicking "Add"
    if (state == 'essential') {
      essentialAmountController.clear();
      essentialNameController.clear();
    } else if (state == 'want') {
      wantAmountController.clear();
      wantNameController.clear();
    } else if (state == 'savings') {
      savingAmountController.clear();
      savingNameController.clear();
    } else if (state == 'income') {
      incomeController.clear();
    }
  }

  // Income methods
  Future<void> displayIncome() async {
    final List<Map<String, dynamic>> data = await dbHelper.queryIncome();
    setState(() {
      incomeList = data;
    });
  }

  Future<void> insertIncome(String amount) async {
    if (amount.isEmpty) return;
    Map<String, dynamic> row = {
      DatabaseHelper.columnAmount: int.parse(amount),
    };
    await dbHelper.insertIncome(row);
    await displayIncome();
    clearText('income');
  }

  Future<void> deleteIncome(int id) async {
    await dbHelper.deleteIncome(id);
    await displayIncome();
  }

  // Essentials methods
  Future<void> displayEssentials() async {
    final List<Map<String, dynamic>> data = await dbHelper.queryEssentials();
    setState(() {
      essentialsList = data;
    });
  }

  Future<void> insertEssentials(String name, String amount) async {
    if (name.isEmpty || amount.isEmpty) return;
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnAmount: int.parse(amount),
    };
    await dbHelper.insertEssential(row);
    await displayEssentials();
    clearText('essential');
  }

  Future<void> deleteEssential(int id) async {
    await dbHelper.deleteEssential(id);
    await displayEssentials();
  }

  // Wants methods
  Future<void> displayWants() async {
    final List<Map<String, dynamic>> data = await dbHelper.queryWants();
    setState(() {
      wantsList = data;
    });
  }

  Future<void> insertWants(String name, String amount) async {
    if (name.isEmpty || amount.isEmpty) return;
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnAmount: int.parse(amount),
    };
    await dbHelper.insertWants(row);
    await displayWants();
    clearText('want');
  }

  Future<void> deleteWant(int id) async {
    await dbHelper.deleteWants(id);
    await displayWants();
  }

  // Savings methods
  Future<void> displaySavings() async {
    final List<Map<String, dynamic>> data = await dbHelper.querySavings();
    setState(() {
      savingsList = data;
    });
  }

  Future<void> insertSavings(String name, String amount) async {
    if (name.isEmpty || amount.isEmpty) return;
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnAmount: int.parse(amount),
    };
    await dbHelper.insertSavings(row);
    await displaySavings();
    clearText('savings');
  }

  Future<void> deleteSaving(int id) async {
    await dbHelper.deleteSavings(id);
    await displaySavings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with logo
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.black, height: 2.0),
        ),
        backgroundColor: Colors.white,
        title: Text("Sign Up"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'Image/FTT.png',
              height: 40,
              width: 40,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Income Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Monthly Income",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: incomeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Income',
                ),
                keyboardType: TextInputType.number,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    insertIncome(incomeController.text);
                  },
                  child: Text("Add"),
                ),
              ),
              SizedBox(height: 10),
              // List of income entries with delete option
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: incomeList.length,
                itemBuilder: (context, index) {
                  final income = incomeList[index];
                  return ListTile(
                    title: Text('Income: \$${income['amount']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteIncome(income['_id']);
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // Essentials Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Essentials",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: essentialNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: essentialAmountController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    insertEssentials(
                      essentialNameController.text,
                      essentialAmountController.text,
                    );
                  },
                  child: Text("Add"),
                ),
              ),
              SizedBox(height: 10),
              // List of essentials entries with delete option
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: essentialsList.length,
                itemBuilder: (context, index) {
                  final essential = essentialsList[index];
                  return ListTile(
                    title: Text('${essential['name']}: \$${essential['amount']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteEssential(essential['_id']);
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // Wants Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Wants",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: wantNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: wantAmountController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    insertWants(
                      wantNameController.text,
                      wantAmountController.text,
                    );
                  },
                  child: Text("Add"),
                ),
              ),
              SizedBox(height: 10),
              // List of wants entries with delete option
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: wantsList.length,
                itemBuilder: (context, index) {
                  final want = wantsList[index];
                  return ListTile(
                    title: Text('${want['name']}: \$${want['amount']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteWant(want['_id']);
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // Savings Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Savings",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: savingNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: savingAmountController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    insertSavings(
                      savingNameController.text,
                      savingAmountController.text,
                    );
                  },
                  child: Text("Add"),
                ),
              ),
              SizedBox(height: 10),
              // List of savings entries with delete option
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: savingsList.length,
                itemBuilder: (context, index) {
                  final saving = savingsList[index];
                  return ListTile(
                    title: Text('${saving['name']}: \$${saving['amount']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteSaving(saving['_id']);
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // Submit Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
                  child: Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}