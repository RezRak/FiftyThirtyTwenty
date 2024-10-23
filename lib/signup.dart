import 'package:flutter/material.dart';
import 'main.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController essentialNameController = TextEditingController();
  final TextEditingController essentialAmountController = TextEditingController();
  final TextEditingController wantNameController = TextEditingController();
  final TextEditingController wantAmountController = TextEditingController();
  final TextEditingController savingNameController = TextEditingController();
  final TextEditingController savingAmountController = TextEditingController();

  void clearText(String state) {
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

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text("Initialization"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Image.asset(
            'Image/FTT.png',
            height: 40,
            width: 40,
          )
        ),
      ],
    ),
    backgroundColor: Colors.white,
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Monthly Income",
              style: TextStyle(fontSize: 18),
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
                  clearText('income');
                },
                child: Text("Add"),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Essentials",
              style: TextStyle(fontSize: 18),
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
                      essentialNameController.text, essentialAmountController.text);
                  clearText('essential');
                },
                child: Text("Add"),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Wants",
              style: TextStyle(fontSize: 18),
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
                      wantNameController.text, wantAmountController.text);
                  clearText('want');
                },
                child: Text("Add"),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Savings",
              style: TextStyle(fontSize: 18),
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
                      savingNameController.text, savingAmountController.text);
                  clearText('savings');
                },
                child: Text("Add"),
              ),
            ),
            SizedBox(height: 20),
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