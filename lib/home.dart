import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'main.dart';

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

    // Update the state with the fetched values
    setState(() {
      if (income != 0) {
        value1 = (essential.toDouble() / income.toDouble()) * 100;
        value2 = (wants.toDouble() / income.toDouble()) * 100;
        value3 = (savings.toDouble() / income.toDouble()) * 100;
        value4 = 100 - (value1 + value2 + value3);
      } else {
        value1 = value2 = value3 = value4 = 0;
      }
    });

    print('Values: value1=$value1, value2=$value2, value3=$value3, value4=$value4');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pie Chart Example'),
      ),
      body: Center(
        child: Container(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: value1,
                  color: Colors.blue,
                  title: 'Essentials\n${value1.toStringAsFixed(1)}%',
                  radius: 80
                ),
                PieChartSectionData(
                  value: value2,
                  color: Colors.green,
                  title: 'Wants\n${value2.toStringAsFixed(1)}%',
                  radius: 80
                ),
                PieChartSectionData(
                  value: value3,
                  color: Colors.yellow,
                  title: 'Savings\n${value3.toStringAsFixed(1)}%',
                  radius: 80
                ),
                PieChartSectionData(
                  value: value4,
                  color: Colors.red,
                  title: 'Remaining\n${value4.toStringAsFixed(1)}%',
                  radius: 80
                ),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ),
    );
  }
}
