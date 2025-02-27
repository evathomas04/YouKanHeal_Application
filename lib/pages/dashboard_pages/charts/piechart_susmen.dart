import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';

class MyPieChart extends StatefulWidget {
  const MyPieChart({super.key});

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  final DatabaseReference _susMenRef =
      FirebaseDatabase.instance.ref('sustainable_menstruation_form');
  int clothPadCount = 0;
  int menstrualCupCount = 0;
  int plasticPadsCount = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    _susMenRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        int clothPad = 0, menstrualCup = 0, plasticPads = 0;

        for (var entry in data.values) {
          if (entry['uses_cloth_pad'] == 'Yes') clothPad++;
          if (entry['uses_menstrual_cup'] == 'Yes') menstrualCup++;
          if (entry['uses_plastic_pads'] == 'Yes') plasticPads++;
        }

        setState(() {
          clothPadCount = clothPad;
          menstrualCupCount = menstrualCup;
          plasticPadsCount = plasticPads;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int total = clothPadCount + menstrualCupCount + plasticPadsCount;
    double clothPadPercentage = total > 0 ? (clothPadCount / total) * 100 : 0;
    double menstrualCupPercentage =
        total > 0 ? (menstrualCupCount / total) * 100 : 0;
    double plasticPadsPercentage =
        total > 0 ? (plasticPadsCount / total) * 100 : 0;

    return Column(
      children: [
        // Legend section
        Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                LegendItem(color: Colors.blue, label: 'Cloth Pads'),
                LegendItem(color: Colors.green, label: 'Menstrual Cups'),
                LegendItem(color: Colors.red, label: 'Plastic Pads'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Pie chart section with constraints
        SizedBox(
          width: 200, // Specify the width
          height: 200, // Specify the height
          child: PieChart(
            // ignore: deprecated_member_use
            swapAnimationDuration: const Duration(milliseconds: 800),
            // ignore: deprecated_member_use
            swapAnimationCurve: Curves.easeInOutQuint,
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: clothPadPercentage,
                  title: '${clothPadPercentage.toStringAsFixed(1)}%',
                  color: Colors.blue,
                  radius: 50,
                ),
                PieChartSectionData(
                  value: menstrualCupPercentage,
                  title: '${menstrualCupPercentage.toStringAsFixed(1)}%',
                  color: Colors.green,
                  radius: 50,
                ),
                PieChartSectionData(
                  value: plasticPadsPercentage,
                  title: '${plasticPadsPercentage.toStringAsFixed(1)}%',
                  color: Colors.red,
                  radius: 50,
                ),
              ],
              centerSpaceRadius: 45,
              sectionsSpace: 2,
            ),
          ),
        ),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
