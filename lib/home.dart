import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'signup.dart';
import 'needs.dart';
import 'wants.dart';
import 'savings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double value1 = 0;
  double value2 = 0;
  double value3 = 0;
  double value4 = 0; // Remaining percentage

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

        double totalPercentage = value1 + value2 + value3;
        value4 = 100 - totalPercentage;

        // Ensure value4 is not negative
        if (value4 < 0) {
          value4 = 0;
        }

        // Test to see if user is over or under budget
        double essentialsLimit = 50.0;
        double wantsLimit = 30.0;
        double savingsLimit = 20.0;

        // Essentials Text if statement
        if (value1 > essentialsLimit) {
          essentialsMessage =
              "Eessentials is less than projected by:  ${(value1 - essentialsLimit).toStringAsFixed(1)}%";
        } else if (value1 < essentialsLimit) {
          essentialsMessage =
              "Eessentials is more than projected by: ${(essentialsLimit - value1).toStringAsFixed(1)}%";
        } else {
          essentialsMessage = "Essentials projected Amount: ${(value1).toStringAsFixed(1)}%";
        }

        // Wants Text if statement
        if (value2 > wantsLimit) {
          wantsMessage =
              "Wants is less than projected by: ${(value2 - wantsLimit).toStringAsFixed(1)}%";
        } else if (value2 < wantsLimit) {
          wantsMessage =
              "Wants is more than projected by: ${(wantsLimit - value2).toStringAsFixed(1)}%";
        } else {
          wantsMessage = "Wants projected Amount: ${(value2).toStringAsFixed(1)}%";
        }

        // Savings Text if statement
        if (value3 < savingsLimit) {
          savingsMessage =
              "Saving less than projected by: ${(savingsLimit - value3).toStringAsFixed(1)}%";
        } else if (value3 > savingsLimit) {
          savingsMessage =
              "Saving more than projected by: ${(value3 - savingsLimit).toStringAsFixed(1)}%";
        } else {
          savingsMessage = "Saving projected Amount: ${(value3).toStringAsFixed(1)}";
        }
      } else {
        value1 = value2 = value3 = value4 = 0;
        essentialsMessage = 'No data';
        wantsMessage = 'No data';
        savingsMessage = 'No data';
      }
    });
  }

  List<PieChartSectionData> buildPieChartSections() {
    List<PieChartSectionData> sections = [];

    if (value1 > 0) {
      sections.add(PieChartSectionData(
        value: value1,
        color: Color.fromARGB(255, 135, 186, 214),
        title: 'Essentials\n${value1.toStringAsFixed(1)}%',
        radius: 80,
        titlePositionPercentageOffset: 0.6,
        titleStyle: TextStyle(fontSize: 14, color: Colors.black),
      ));
    }

    if (value2 > 0) {
      sections.add(PieChartSectionData(
        value: value2,
        color: Color.fromARGB(255, 230, 198, 75),
        title: 'Wants\n${value2.toStringAsFixed(1)}%',
        radius: 80,
        titlePositionPercentageOffset: 0.6,
        titleStyle: TextStyle(fontSize: 14, color: Colors.black),
      ));
    }

    if (value3 > 0) {
      sections.add(PieChartSectionData(
        value: value3,
        color: Color.fromARGB(255, 143, 196, 143),
        title: 'Savings\n${value3.toStringAsFixed(1)}%',
        radius: 80,
        titlePositionPercentageOffset: 0.6,
        titleStyle: TextStyle(fontSize: 14, color: Colors.black),
      ));
    }

    // Only add the 'Remaining' section if value4 is positive and greater than zero
    if (value4 > 0) {
      sections.add(PieChartSectionData(
        value: value4,
        color: const Color.fromARGB(255, 200, 200, 180),
        title: 'Remaining\n${value4.toStringAsFixed(1)}%',
        radius: 80,
        titlePositionPercentageOffset: 0.6,
        titleStyle: TextStyle(fontSize: 14, color: Colors.black),
      ));
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> pieChartSections = buildPieChartSections();

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
          const SizedBox(width: 50),
          SizedBox(height: 20),
          Text(
            "Welcome!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            "This is your total spending summary",
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
                      'Income',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${income.toString()}',
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const SizedBox(height: 10),
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
        const Spacer(),
        Container(height: 2, color: Colors.black, width: double.infinity),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(40, 49, 49, 49),
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
      ],
    ),
  );
}
}