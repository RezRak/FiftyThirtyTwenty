import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ftt/needs.dart';
import 'package:ftt/savings.dart';
import 'package:ftt/wants.dart';
import 'main.dart';
import 'signup.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double value1 = 0;
  double value2 = 0;
  double value3 = 0;
  double value4 = 0;

  String essentialsMessage = '';
  String wantsMessage = '';
  String savingsMessage = '';

  int income = 0; 

  @override
  void initState() {
    super.initState();
    getUpdateData();
  }

Future<void> getUpdateData() async {
  // Grab int values from each table
  int fetchedIncome = await dbHelper.sumIncome(); 
  int essential = await dbHelper.sumEssentials();
  int wants = await dbHelper.sumWants();
  int savings = await dbHelper.sumSavings();

  setState(() {
    income = fetchedIncome; // Assign the fetched income to the instance variable
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

        // Essentials Text if statement
        if (value1 > essentialsLimit) {
          essentialsMessage = "You're Spending ${(value1 - essentialsLimit).toStringAsFixed(1)}% over the limit";
        } else if (value1 < essentialsLimit) {
          essentialsMessage = "You've spent less than essentials target by ${(essentialsLimit - value1).toStringAsFixed(1)}%";
        } else {
          essentialsMessage = "You're on Track";
        }

        // Wants Text if statement
        if (value2 > wantsLimit) {
          wantsMessage = "You're Spending ${(value2 - wantsLimit).toStringAsFixed(1)}% over the limit";
        } else if (value2 < wantsLimit) {
          wantsMessage = "You've spent less than wants target by ${(wantsLimit - value2).toStringAsFixed(1)}%";
        } else {
          wantsMessage = "You're on Track";
        }

      // Savings Text if statement
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
          child: Container(color: Colors.black, height: 2.0),
        ),
        backgroundColor: Colors.white,
        title: const Text("Home", style: TextStyle(color: Colors.black)),
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
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(onPressed:  () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
            }, 
            child: 
              const Icon(Icons.edit))
          ),
          SizedBox(
            height: 400,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Income',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        '\$${income.toString()}',
                      style: const TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(height: 2, color: Colors.black, width: double.infinity),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Text(
                  essentialsMessage,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Text(
                  wantsMessage,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Text(
                  savingsMessage,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Container(height: 2, color: Colors.black, width: double.infinity),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {},
                child: const Icon(Icons.home),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Essential()),
                  );
                },
                child: const Icon(Icons.business),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Want()),
                  );
                },
                child: const Icon(Icons.favorite),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Saving()),
                  );
                },
                child: const Icon(Icons.attach_money),
              ),
            ],
          ),
        ],
      ),
    );
  }
}