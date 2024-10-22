import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'main.dart';

void main() {
  runApp(const Home());
}

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
      value1 = income.toDouble();
      value2 = essential.toDouble();
      value3 = wants.toDouble();
      value4 = savings.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pie Chart Example'),
      ),
      body: PieChart(
        swapAnimationDuration: const Duration(milliseconds: 250),
        swapAnimationCurve: Curves.bounceIn,
        PieChartData(
          sections: [
            PieChartSectionData(
              value: value1,
              color: Colors.blue,
              title: value1.toString(),
            ),
            PieChartSectionData(
              value: value2,
              color: Colors.green,
              title: value2.toString(),
            ),
            PieChartSectionData(
              value: value3,
              color: Colors.yellow,
              title: value3.toString(),
            ),
            PieChartSectionData(
              value: value4,
              color: Colors.red,
              title: value4.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
