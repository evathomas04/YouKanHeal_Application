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
      FirebaseDatabase.instance.ref('ban_the_bag_form');
  int clothCount = 0;
  int juteCount = 0;
  int paperCount = 0;
  int plasticCount = 0;
  int otherCount = 0;

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
        int cloth = 0, jute = 0, paper = 0, plastic = 0, other = 0;

        for (var entry in data.values) {
          if (entry['reusable_bag_material'] == 'Cloth') cloth++;
          if (entry['reusable_bag_material'] == 'Jute') jute++;
          if (entry['reusable_bag_material'] == 'Paper') paper++;
          if (entry['reusable_bag_material'] == 'Plastic') plastic++;
          if (entry['reusable_bag_material'] == 'Other') other++;
        }

        setState(() {
          clothCount = cloth;
          juteCount = jute;
          paperCount = paper;
          plasticCount = plastic;
          otherCount = other;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int total = clothCount + juteCount + paperCount + plasticCount + otherCount;
    double clothPercentage = total > 0 ? (clothCount / total) * 100 : 0;
    double jutePercentage = total > 0 ? (juteCount / total) * 100 : 0;
    double paperPercentage = total > 0 ? (paperCount / total) * 100 : 0;
    double plasticPercentage = total > 0 ? (plasticCount / total) * 100 : 0;
    double otherPercentage = total > 0 ? (otherCount / total) * 100 : 0;

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
                LegendItem(color: Colors.blue, label: 'Cloth'),
                LegendItem(color: Colors.green, label: 'Jute'),
                LegendItem(color: Colors.red, label: 'Paper'),
                LegendItem(color: Colors.yellow, label: 'Plastic'),
                LegendItem(color: Colors.pink, label: 'Plastic Pads'),
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
                  value: clothPercentage,
                  title: '${clothPercentage.toStringAsFixed(1)}%',
                  color: Colors.blue,
                  radius: 50,
                ),
                PieChartSectionData(
                  value: jutePercentage,
                  title: '${jutePercentage.toStringAsFixed(1)}%',
                  color: Colors.green,
                  radius: 50,
                ),
                PieChartSectionData(
                  value: paperPercentage,
                  title: '${paperPercentage.toStringAsFixed(1)}%',
                  color: Colors.red,
                  radius: 50,
                ),
                PieChartSectionData(
                  value: plasticPercentage,
                  title: '${plasticPercentage.toStringAsFixed(1)}%',
                  color: Colors.yellow,
                  radius: 50,
                ),
                PieChartSectionData(
                  value: otherPercentage,
                  title: '${otherPercentage.toStringAsFixed(1)}%',
                  color: Colors.pink,
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
