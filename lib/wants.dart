import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'home.dart';
import 'savings.dart';
import 'needs.dart'; // Assuming 'needs.dart' corresponds to essentials

class Want extends StatefulWidget {
  const Want({super.key});

  @override
  _WantState createState() => _WantState();
}

class _WantState extends State<Want> {
  List<Map<String, dynamic>> wantsList = [];
  List<PieChartSectionData> pieChartSections = [];
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    getWantsData();
  }

  Future<void> getWantsData() async {
    wantsList = await dbHelper.queryWants();

    setState(() {
      totalAmount = wantsList.fold(0, (sum, item) => sum + item['amount']);

      if (totalAmount > 0) {
        pieChartSections = wantsList.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> item = entry.value;
          final percentage = (item['amount'] / totalAmount) * 100;

          return PieChartSectionData(
            value: percentage,
            color: getColor(index),
            title: '${item['name']}\n${percentage.toStringAsFixed(1)}%',
            radius: 50,
            titlePositionPercentageOffset: 1.6,
            titleStyle: TextStyle(fontSize: 12, color: Colors.black),
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
        title: Text("Wants", style: TextStyle(color: Colors.black)),
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
          height: 400,
          width: double.infinity,
          child: pieChartSections.isNotEmpty
              ? PieChart(
                  PieChartData(
                    sections: pieChartSections,
                    sectionsSpace: 2,
                    centerSpaceRadius: 80,
                  ),
                )
              : Center(child: Text('No data available')),
        ),
        SizedBox(height: 5),
        Container(height: 2, color: Colors.black, width: double.infinity),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: wantsList.length,
            itemBuilder: (context, index) {
              final item = wantsList[index];
              final percentage = (item['amount'] / totalAmount) * 100;

              return ListTile(
                title: Text('${item['name']}: \$${item['amount']}'),
                subtitle:
                    Text('${percentage.toStringAsFixed(1)}% of total wants'),
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
              onPressed: () {},
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