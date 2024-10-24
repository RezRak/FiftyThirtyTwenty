import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'database.dart';
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
    int income = await dbHelper.sumIncome();
    int essential = await dbHelper.sumEssentials();
    int wants = await dbHelper.sumWants();
    int savings = await dbHelper.sumSavings();

    setState(() {
      if (income != 0) {
        value1 = (essential.toDouble() / income.toDouble()) * 100;
        value2 = (wants.toDouble() / income.toDouble()) * 100;
        value3 = (savings.toDouble() / income.toDouble()) * 100;
        value4 = 100 - (value1 + value2 + value3);

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
        backgroundColor: Colors.white,
        title: Text("Home"),
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
          Container(
            height: 500,
            width: double.infinity,
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
          Container(
            height: 2,
            color: Colors.black,
            width: double.infinity
          ),
          SizedBox(height: 50),
          Padding(
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
          SizedBox(height: 60),
          Container(
            height: 2,
            color: Colors.black,
            width: double.infinity,
          ),
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
                child: Text('Home'),
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
                child: Text('Essentials'),
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
                child: Text('Wants'),
              ),
              TextButton(
                onPressed: () {
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                child: Text('Savings'),
              ),
            ],
          ),
        ]
      )
    );
  }
}