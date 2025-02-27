import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';

class MyPieChart extends StatefulWidget {
  const MyPieChart({super.key});

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  final DatabaseReference _greenProtocolRef =
      FirebaseDatabase.instance.ref('green_protocol_form');

  // Map to store counts for each item
  Map<String, int> itemCounts = {
    'Reusable Glass': 0,
    'Reusable Plates': 0,
    'Reusable Spoon': 0,
    'Reusable Bowls': 0,
    'Nature Friendly Decorations': 0,
    'Edible Cutlery': 0,
    'Eco Friendly Banner': 0,
    'Eco Friendly Bags': 0,
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    _greenProtocolRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;

        // Process each entry and count the selected items
        for (var entry in data.values) {
          if (entry['items_used'] != null) {
            List<dynamic> itemsUsed = List.from(entry['items_used']);
            for (var item in itemsUsed) {
              item = item.trim(); // Ensure no leading or trailing spaces
              if (itemCounts.containsKey(item)) {
                setState(() {
                  itemCounts[item] = itemCounts[item]! + 1;
                });
              }
            }
          }
        }

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalResponses = itemCounts.values.fold(0, (sum, count) => sum + count);
    // Calculate the percentage for each item
    Map<String, double> itemPercentages = {};
    itemCounts.forEach((item, count) {
      itemPercentages[item] =
          totalResponses > 0 ? (count / totalResponses) * 100 : 0;
    });

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
              children: itemCounts.keys.map((item) {
                return LegendItem(color: _getItemColor(item), label: item);
              }).toList(),
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
              sections: itemCounts.keys.map((item) {
                return PieChartSectionData(
                  value: itemPercentages[item]!,
                  title: '${itemPercentages[item]!.toStringAsFixed(1)}%',
                  color: _getItemColor(item),
                  radius: 50,
                );
              }).toList(),
              centerSpaceRadius: 45,
              sectionsSpace: 2,
            ),
          ),
        ),
      ],
    );
  }
}

// Helper method to get color for each item
Color _getItemColor(String item) {
  switch (item) {
    case 'Reusable Glass':
      return Colors.blue;
    case 'Reusable Plates':
      return Colors.green;
    case 'Reusable Spoon':
      return Colors.orange;
    case 'Reusable Bowls':
      return Colors.purple;
    case 'Nature Friendly Decorations':
      return Colors.yellow;
    case 'Edible Cutlery':
      return Colors.red;
    case 'Eco Friendly Banner':
      return Colors.cyan;
    case 'Eco Friendly Bags':
      return Colors.teal;
    default:
      return Colors.black;
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
