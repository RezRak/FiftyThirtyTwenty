import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'home.dart';
import 'needs.dart';
import 'wants.dart';

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
    income = await dbHelper.sumIncome(); // Fetch total income

    setState(() {
      totalAmount = savingsList.fold(0, (sum, item) => sum + item['amount']);

      // Compute target amount for savings (20% of income)
      targetAmount = income * 0.20;

      // Compute difference between actual amount and target amount
      difference = totalAmount - targetAmount;

      // Create budget message
      if (income > 0) {
        if (difference < 0) {
          budgetMessage =
              "You are under budget for savings. You need to save \$${difference.abs().toStringAsFixed(2)} more.";
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
            radius: 80, // Increased radius
            titlePositionPercentageOffset: 0.6, // Adjusted offset
            titleStyle: TextStyle(fontSize: 14, color: Colors.black),
          );
        }).toList();
      } else {
        pieChartSections = [];
      }
    });
  }

  List<Color> predefinedColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.indigo,
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
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          height: 400, // Increased height from 300 to 400
          width: double.infinity,
          child: pieChartSections.isNotEmpty
              ? PieChart(
                  PieChartData(
                    sections: pieChartSections,
                    sectionsSpace: 2,
                    centerSpaceRadius: 50, // Adjusted center space radius
                  ),
                )
              : Center(child: Text('No data available')),
        ),
        SizedBox(height: 5),
        Container(height: 2, color: Colors.black, width: double.infinity),
        SizedBox(height: 20),
        Text(
          budgetMessage,
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: savingsList.length,
            itemBuilder: (context, index) {
              final item = savingsList[index];
              final percentage = (item['amount'] / totalAmount) * 100;

              return ListTile(
                title: Text('${item['name']}: \$${item['amount']}'),
                subtitle:
                    Text('${percentage.toStringAsFixed(1)}% of total savings'),
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
                backgroundColor: Colors.transparent,
              ),
              child: const Icon(Icons.attach_money),
            ),
          ],
        ),
      ]),
    );
  }
}