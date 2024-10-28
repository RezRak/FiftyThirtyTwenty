import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'home.dart';
import 'savings.dart';
import 'wants.dart';
import 'signup.dart';

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
    essentialsList = await dbHelper.queryEssentials(); // Fetch needs data
    income = await dbHelper.sumIncome();

    setState(() {
      totalAmount = essentialsList.fold(0, (sum, item) => sum + item['amount']);
      targetAmount = income * 0.50; // 50% target for needs
      difference = totalAmount - targetAmount;

      if (income > 0) {
        if (difference < 0) {
          budgetMessage =
              "You are under budget for needs. You can spend \$${difference.abs().toStringAsFixed(2)} more.";
        } else if (difference > 0) {
          budgetMessage =
              "You are \$${difference.toStringAsFixed(2)} over budget. Adjust your spending to meet your target.";
        } else {
          budgetMessage = "You are on budget for needs.";
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
            radius: 80,
            titlePositionPercentageOffset: 0.6,
            titleStyle: TextStyle(fontSize: 14, color: Colors.black),
          );
        }).toList();
      } else {
        pieChartSections = [];
      }
    });
  }

  List<Color> predefinedColors = [
    Color.fromARGB(255, 173, 216, 230),
    Color.fromARGB(255, 158, 202, 225),
    Color.fromARGB(255, 135, 186, 214),
    Color.fromARGB(255, 109, 167, 201),
    Color.fromARGB(255, 84, 150, 186),
    Color.fromARGB(255, 67, 133, 174),
    Color.fromARGB(255, 52, 119, 161),
    Color.fromARGB(255, 38, 103, 145),
    Color.fromARGB(255, 28, 82, 121),
    Color.fromARGB(255, 19, 63, 96),
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
        SizedBox(height: 20),
        Text(
          "Essentials",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "This is your spending summary in Essentials",
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
        SizedBox(height: 5),
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
                    'Essential',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 3),
        Text(
          budgetMessage,
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: essentialsList.length,
            itemBuilder: (context, index) {
              final item = essentialsList[index];
              final percentage = (item['amount'] / totalAmount) * 100;

              return ListTile(
                title: Text('${item['name']}: \$${item['amount']}'),
                subtitle: Text('${percentage.toStringAsFixed(1)}% of total savings'),
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
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(40, 49, 49, 49),
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
