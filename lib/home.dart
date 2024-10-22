import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'database.dart';


void main() {
  runApp(const Home());
}

void getUpdateData() {


}


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      swapAnimationDuration: const Duration(milliseconds: 250), 
      swapAnimationCurve: Curves.bounceIn,
      PieChartData(
        sections: [
          PieChartSectionData(
            value: value1,
            color: Colors.blue,
          ),
          PieChartSectionData(
            value: value2,
            color: Colors.blue,
          ),

          PieChartSectionData(
            value: value3,
            color: Colors.blue,
          ),

          PieChartSectionData(
            value: value4,
            color: Colors.blue,
          ),
        ]
      )
    );
  }
}