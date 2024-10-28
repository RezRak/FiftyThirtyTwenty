import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'home.dart';
import 'needs.dart';
import 'wants.dart';
import 'signup.dart';

class Saving extends StatefulWidget {
  const Saving({super.key});

  @override
  _SavingState createState() => _SavingState();
}

class _SavingState extends State<Saving> {
  List<Map<String, dynamic>> savingsList = [];
  List<PieChartSectionData> pieChartSections = [];
  double totalAmount = 0;
  int income = 0;
  double targetAmount = 0;
  double difference = 0;
  String budgetMessage = '';

  @override
  void initState() {
    super.initState();
    getSavingsData();
  }

  Future<void> getSavingsData() async {
    savingsList = await dbHelper.querySavings();
    income = await dbHelper.sumIncome();

    setState(() {
      totalAmount = savingsList.fold(0, (sum, item) => sum + item['amount']);
      targetAmount = income * 0.20;  // 20% savings target
      difference = totalAmount - targetAmount;

      if (income > 0) {
        if (difference < 0) {
          budgetMessage =
              "You are under budget for savings. Save \$${difference.abs().toStringAsFixed(2)} more.";
        } else if (difference > 0) {
          budgetMessage =
              "Great job! You have saved \$${difference.toStringAsFixed(2)} more than your target.";
        } else {
          budgetMessage = "You have met your savings target.";
        }
      } else {
        budgetMessage = "Please enter your income to see budget details.";
      }

      if (totalAmount > 0) {
        pieChartSections = savingsList.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> item = entry.value;
          final percentage = (item['amount'] / totalAmount) * 100;

          return PieChartSectionData(
            value: percentage,
            color: getColor(index),
            title: '${item['name']}\n${percentage.toStringAsFixed(1)}%',
            radius: 80,
            titlePositionPercentageOffset: 0.6,
            titleStyle: TextStyle(fontSize: 14, color: Colors.black),
          );
        }).toList();
      } else {
        pieChartSections = [];
      }
    });
  }

  List<Color> predefinedColors = [
    Color.fromARGB(255, 178, 216, 178),
    Color.fromARGB(255, 163, 207, 163),
    Color.fromARGB(255, 143, 196, 143), 
    Color.fromARGB(255, 122, 175, 122), 
    Color.fromARGB(255, 111, 159, 111), 
    Color.fromARGB(255, 94, 142, 94),  
    Color.fromARGB(255, 84, 127, 84),   
    Color.fromARGB(255, 74, 111, 74),  
    Color.fromARGB(255, 53, 82, 53),
  ];

  Color getColor(int index) {
    return predefinedColors[index % predefinedColors.length];
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.black, height: 2.0)),
      backgroundColor: Colors.white,
      title: Text("Savings", style: TextStyle(color: Colors.black)),
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
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "Savings",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "This is your spending summary in savings",
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUp()));
          },
          child: const Icon(Icons.edit),
        ),
        SizedBox(height: 5),
        SizedBox(
          height: 400,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              pieChartSections.isNotEmpty
                  ? PieChart(
                      PieChartData(
                        sections: pieChartSections,
                        sectionsSpace: 2,
                        centerSpaceRadius: 50,
                      ),
                    )
                  : Center(child: Text('No data available')),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Savings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 3),
        Text(
          budgetMessage,
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: savingsList.length,
            itemBuilder: (context, index) {
              final item = savingsList[index];
              final percentage = (item['amount'] / totalAmount) * 100;

              return ListTile(
                title: Text('${item['name']}: \$${item['amount']}'),
                subtitle: Text('${percentage.toStringAsFixed(1)}% of total savings'),
              );
            },
          ),
        ),
        Container(height: 2, color: Colors.black, width: double.infinity),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              child: const Icon(Icons.home),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Essential()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              child: const Icon(Icons.business),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Want()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              child: const Icon(Icons.favorite),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(40, 49, 49, 49),
              ),
              child: const Icon(Icons.attach_money),
            ),
          ],
        ),
      ],
    ),
  );
}
}
