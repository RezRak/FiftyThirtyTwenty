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

  void clearText(state) {
    if(state == 'essential') {
      essentialAmountController.clear();
      essentialNameController.clear();
    }
    else if(state == 'want') {
      wantAmountController.clear();
      wantNameController.clear();
    }
    else if(state == 'savings'){
      savingAmountController.clear();
      savingNameController.clear();
    }
    else if(state == 'income') {
      incomeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Initialization"),
      ),
      body: Center(
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
            ),
            ElevatedButton(
              onPressed: () {
                insertIncome(essentialAmountController);
                clearText('income');
              },
              child: Text("Add"),
            ),

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
            ),
            ElevatedButton(
              onPressed: () {
                insertEssentials(essentialNameController.text, essentialAmountController.value);
                clearText('essential');
              },
              child: Text("Add"),
            ),

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
            ),
            ElevatedButton(
              onPressed: () {
                insertWants(essentialNameController.text, essentialAmountController.value);
                clearText('want');
              },
              child: Text("Add"),
            ),

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
            ),
            ElevatedButton(
              onPressed: () {
                insertSavings(essentialNameController.text, essentialAmountController.value);
                clearText('savings');
              },
              child: Text("Add"),
            ),
            SizedBox(width: 10, height: 10),
            ElevatedButton(
              onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()));
              },
              child: Text("Submit"),
            )
          ],
        ),
      )
    );
  }
}
      