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
        title: Text("Initialization"),
      ),
      body: SingleChildScrollView( // Added to prevent overflow
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Monthly Income"),
              TextField(
                controller: incomeController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Income',
                ),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  insertIncome(incomeController.text);
                  clearText('income');
                },
                child: Text("Add"),
              ),
              SizedBox(height: 20),
              Text("Essentials"),
              TextField(
                controller: essentialNameController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: essentialAmountController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  insertEssentials(
                      essentialNameController.text, essentialAmountController.text);
                  clearText('essential');
                },
                child: Text("Add"),
              ),
              SizedBox(height: 20),
              Text("Wants"),
              TextField(
                controller: wantNameController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: wantAmountController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  insertWants(wantNameController.text, wantAmountController.text);
                  clearText('want');
                },
                child: Text("Add"),
              ),
              SizedBox(height: 20),
              Text("Savings"),
              TextField(
                controller: savingNameController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: savingAmountController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  insertSavings(
                      savingNameController.text, savingAmountController.text);
                  clearText('savings');
                },
                child: Text("Add"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => const Home()));
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
