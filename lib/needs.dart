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
  double value1 = 0;
  double value2 = 0;
  double value3 = 0;
  double value4 = 0;

  String essentialsMessage = '';
  String wantsMessage = '';
  String savingsMessage = '';

  @override
  void initState() {
    super.initState();
    getUpdateData();
  }

  Future<void> getUpdateData() async {
    // Grab int values from each table
    int income = await dbHelper.sumIncome(); 
    int essential = await dbHelper.sumEssentials();
    int wants = await dbHelper.sumWants();
    int savings = await dbHelper.sumSavings();

    setState(() {
      // Gathers the percentage of each value to add into pie chart later
      if (income != 0) {
        value1 = (essential.toDouble() / income.toDouble()) * 100;
        value2 = (wants.toDouble() / income.toDouble()) * 100;
        value3 = (savings.toDouble() / income.toDouble()) * 100;
        value4 = 100 - (value1 + value2 + value3);

        // Test to see if user is over or under budget
        double essentialsLimit = 50.0;
        double wantsLimit = 30.0;
        double savingsLimit = 20.0;

        if (value1 > essentialsLimit) {
          essentialsMessage = "You're Spending ${(value1 - essentialsLimit).toStringAsFixed(1)}% over the limit";
        } else if (value1 < essentialsLimit) {
          essentialsMessage = "You've lessened your spending by ${(essentialsLimit - value1).toStringAsFixed(1)}%";
        } else {
          essentialsMessage = "You're on Track";
        }

        if (value2 > wantsLimit) {
          wantsMessage = "You're Spending ${(value2 - wantsLimit).toStringAsFixed(1)}% over the limit";
        } else if (value2 < wantsLimit) {
          wantsMessage = "You've lessened your spending by ${(wantsLimit - value2).toStringAsFixed(1)}%";
        } else {
          wantsMessage = "You're on Track";
        }

        if (value3 < savingsLimit) {
          savingsMessage = "You're Saving ${(savingsLimit - value3).toStringAsFixed(1)}% less than you should be";
        } else if (value3 > savingsLimit) {
          savingsMessage = "You're Saving ${(value3 - savingsLimit).toStringAsFixed(1)}% more";
        } else {
          savingsMessage = "You're on Track";
        }
      } else {
        value1 = value2 = value3 = value4 = 0;
        essentialsMessage = 'No data';
        wantsMessage = 'No data';
        savingsMessage = 'No data';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0), 
          child: Container(
            color: Colors.black,
            height: 2.0
          )),
        backgroundColor: Colors.white,
        title: Text("Essentials"),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 500,
            width: double.infinity,
            // Piechart data and UI
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: value1,
                    color: const Color.fromARGB(255, 47, 139, 215),
                    title: 'Essentials\n${value1.toStringAsFixed(1)}%',
                    radius: 50,
                    titlePositionPercentageOffset: 1.8,
                  ),
                  PieChartSectionData(
                    value: value2,
                    color: const Color.fromARGB(255, 221, 61, 55),
                    title: 'Wants\n${value2.toStringAsFixed(1)}%',
                    radius: 50,
                    titlePositionPercentageOffset: 1.8,
                  ),
                  PieChartSectionData(
                    value: value3,
                    color: const Color.fromARGB(255, 255, 235, 57),
                    title: 'Savings\n${value3.toStringAsFixed(1)}%',
                    radius: 50,
                    titlePositionPercentageOffset: 1.8,
                  ),
                  PieChartSectionData(
                    value: value4,
                    color: const Color.fromARGB(255, 127, 127, 127),
                    title: 'Remaining\n${value4.toStringAsFixed(1)}%',
                    radius: 50,
                    titlePositionPercentageOffset: 1.8,
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 90,
              ),
            ),
          ),
          SizedBox(height: 5),
          // Black line between Pie chart and Text information
          Container(
            height: 2,
            color: Colors.black,
            width: double.infinity
          ),
          SizedBox(height: 50),
          Padding(
            // Text for determining if over or under budget
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Text(
                  essentialsMessage,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Text(
                  wantsMessage,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Text(
                  savingsMessage,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),         
          // Second black line for the bottom button bar
          SizedBox(height: 60),
          Container(
            height: 2,
            color: Colors.black,
            width: double.infinity,
          ),
          // Creates buttons for Navigation to other tabs
          Spacer(),
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
        ]
      )
    );
  }
}