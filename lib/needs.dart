import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'home.dart';
import 'savings.dart';
import 'wants.dart';

class Essential extends StatefulWidget {
  const Essential({super.key});

  @override
  _EssentialState createState() => _EssentialState();
}

class _EssentialState extends State<Essential> {
  List<Map<String, dynamic>> essentialsList = [];
  List<PieChartSectionData> pieChartSections = [];
  double totalAmount = 0;
  int income = 0;
  double targetAmount = 0;
  double difference = 0;
  String budgetMessage = '';

  @override
  void initState() {
    super.initState();
    getEssentialsData();
  }

  Future<void> getEssentialsData() async {
    essentialsList = await dbHelper.queryEssentials();
    income = await dbHelper.sumIncome(); // Fetch total income

    setState(() {
      totalAmount =
          essentialsList.fold(0, (sum, item) => sum + item['amount']);

      // Compute target amount for essentials (50% of income)
      targetAmount = income * 0.50;

      // Compute difference between actual amount and target amount
      difference = totalAmount - targetAmount;

      // Create budget message
      if (income > 0) {
        if (difference < 0) {
          budgetMessage =
              "You are under budget for essentials. You can spend \$${difference.abs().toStringAsFixed(2)} more.";
        } else if (difference > 0) {
          budgetMessage =
              "You are \$${difference.toStringAsFixed(2)} over budget. Adjust your spending to meet your target.";
        } else {
          budgetMessage = "You are on budget for essentials.";
        }
      } else {
        budgetMessage = "Please enter your income to see budget details.";
      }

      if (totalAmount > 0) {
        pieChartSections = essentialsList.asMap().entries.map((entry) {
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
        title: Text("Essentials", style: TextStyle(color: Colors.black)),
        actions: [
          // Adds the logo on the appbar
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
          // Piechart data and UI
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
        // Black line between Pie chart and Text information
        Container(height: 2, color: Colors.black, width: double.infinity),
        SizedBox(height: 20),
        Text(
          budgetMessage,
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Expanded(
          // List of essential entries
          child: ListView.builder(
            itemCount: essentialsList.length,
            itemBuilder: (context, index) {
              final item = essentialsList[index];
              final percentage = (item['amount'] / totalAmount) * 100;

              return ListTile(
                title: Text('${item['name']}: \$${item['amount']}'),
                subtitle: Text(
                    '${percentage.toStringAsFixed(1)}% of total essentials'),
              );
            },
          ),
        ),
        // Second black line for the bottom button bar
        Container(height: 2, color: Colors.black, width: double.infinity),
        // Creates buttons for Navigation to other tabs
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
              onPressed: () {},
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
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Saving()),
                );
              },
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