import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'database.dart';


  void main() {
    runApp(const Home());
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
            value: 20,
            color: Colors.blue,
          ),
          PieChartSectionData(
            value: 20,
            color: Colors.blue,
          ),

          PieChartSectionData(
            value: 20,
            color: Colors.blue,
          ),

          PieChartSectionData(
            value: 20,
            color: Colors.blue,
          ),
        ]
      )
    );
  }
}