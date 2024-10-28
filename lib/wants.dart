import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'home.dart';
import 'savings.dart';
import 'needs.dart';
import 'signup.dart';

class Want extends StatefulWidget {
  const Want({super.key});

  @override
  _WantState createState() => _WantState();
}

class _WantState extends State<Want> {
  List<Map<String, dynamic>> wantsList = [];
  List<PieChartSectionData> pieChartSections = [];
  double totalAmount = 0;
  int income = 0;
  double targetAmount = 0;
  double difference = 0;
  String budgetMessage = '';

  @override
  void initState() {
    super.initState();
    getWantsData();
  }

  Future<void> getWantsData() async {
    wantsList = await dbHelper.queryWants();
    income = await dbHelper.sumIncome(); // Fetch total income

    setState(() {
      totalAmount = wantsList.fold(0, (sum, item) => sum + item['amount']);

      // Compute target amount for wants (30% of income)
      targetAmount = income * 0.30;

      // Compute difference between actual amount and target amount
      difference = totalAmount - targetAmount;

      // Create budget message
      if (income > 0) {
        if (difference < 0) {
          budgetMessage =
              "You are under budget for wants. You can spend \$${difference.abs().toStringAsFixed(2)} more.";
        } else if (difference > 0) {
          budgetMessage =
              "You are \$${difference.toStringAsFixed(2)} over budget. Adjust your spending to meet your target.";
        } else {
          budgetMessage = "You are on budget for wants.";
        }
      } else {
        budgetMessage = "Please enter your income to see budget details.";
      }

      if (totalAmount > 0) {
        pieChartSections = wantsList.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> item = entry.value;
          final percentage = (item['amount'] / totalAmount) * 100;

          return PieChartSectionData(
            value: percentage,
            color: getColor(index),
            title: '${item['name']}\n${percentage.toStringAsFixed(1)}%',
            radius: 80, // Increased radius
            titlePositionPercentageOffset: 0.6, // Adjusted offset
            titleStyle: TextStyle(fontSize: 14, color: Colors.black),
          );
        }).toList();
      } else {
        pieChartSections = [];
      }
    });
  }

  List<Color> predefinedColors = [
    Color.fromARGB(255, 255, 223, 100),
    Color.fromARGB(255, 240, 210, 90),
    Color.fromARGB(255, 230, 198, 75),
    Color.fromARGB(255, 215, 180, 60),
    Color.fromARGB(255, 195, 160, 50),
    Color.fromARGB(255, 175, 145, 55),
    Color.fromARGB(255, 150, 120, 50),
    Color.fromARGB(255, 130, 105, 60),
    Color.fromARGB(255, 110, 90, 65),
    Color.fromARGB(255, 90, 75, 55),
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
    body: Column( mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "Wants",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "This is your spending summary in wants",
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
                      'Wants',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${totalAmount.toStringAsFixed(2)}',
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
      ]
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
                backgroundColor: const Color.fromARGB(40, 49, 49, 49),
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