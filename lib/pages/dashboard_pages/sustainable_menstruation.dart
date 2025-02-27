import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:youkanheal_mainproject/pages/dashboard_pages/charts/linechart_susmen.dart';
import 'charts/piechart_susmen.dart';

class SustainableMenstruation extends StatefulWidget {
  final String message;

  const SustainableMenstruation({super.key, required this.message});

  @override
  _SustainableMenstruationState createState() =>
      _SustainableMenstruationState();
}

class _SustainableMenstruationState extends State<SustainableMenstruation> {
  final DatabaseReference _sustainableMenstruationRef =
      FirebaseDatabase.instance.ref('sustainable_menstruation_form');

  List<double> sustainableMenstruationCounts =
      List.filled(3, 0); // For the last 3 months
  List<String> monthNames = []; // To hold month names for x-axis

  int _totalParticipants = 0;
  int _willingToParticipate = 0;
  int _totalPadsReduced = 0;
  // List<String> _institutions = [];

  @override
  void initState() {
    super.initState();
    _initializeListeners();
    initializeMonthNames();
    fetchData(); // Fetch data after initializing month names
  }
  // _fetchInstitutions();

  // Initialize month names for the last 3 months
  void initializeMonthNames() {
    DateTime now = DateTime.now();
    monthNames = List.generate(3, (index) {
      DateTime monthDate = DateTime(now.year, now.month - index);
      return getMonthName(monthDate.month);
    }).reversed.toList();
  }

  // Convert month number to month name
  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  // Fetch data for both Ban the Bag and Sustainable Menstruation
  void fetchData() {
    resetCounts(); // Reset counts before starting any processing

    DateTime now = DateTime.now();
    _sustainableMenstruationRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        for (var entry in data.entries) {
          if (entry.value['willing_to_participate'] == 'Yes') {
            var timestamp = entry.value['timestamp'];
            DateTime? date = _parseTimestamp(timestamp, now);
            if (date != null) {
              int monthIndex =
                  (now.year - date.year) * 12 + now.month - date.month;
              if (monthIndex >= 0 && monthIndex < 3) {
                sustainableMenstruationCounts[2 - monthIndex]++;
              }
            }
          }
        }
        setState(() {}); // Update UI
      } else {
        print('No Sustainable Menstruation data available.');
      }
    });
  }

  // Helper function to parse timestamp
  DateTime? _parseTimestamp(dynamic timestamp, DateTime fallback) {
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else if (timestamp is String) {
      return DateTime.tryParse(timestamp);
    }
    return null; // Return null for unsupported formats
  }

  // Reset counts before recalculating
  void resetCounts() {
    sustainableMenstruationCounts.fillRange(
        0, sustainableMenstruationCounts.length, 0);
  }

  // void _fetchInstitutions() {
  //   FirebaseDatabase.instance.ref('institutions').get().then((snapshot) {
  //     if (snapshot.exists) {
  //       final data = snapshot.value as Map<dynamic, dynamic>;
  //       List<String> institutions = [];
  //       data.forEach((key, value) {
  //         institutions.add(value.toString());
  //       });
  //       setState(() {
  //         _institutions = institutions;
  //       });
  //     }
  //   });
  // }

  void _initializeListeners() {
    _sustainableMenstruationRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        int totalParticipants = 0;
        int willingToParticipate = 0;
        int totalPadsReduced = 0;

        data.forEach((key, value) {
          totalParticipants++;
          if (value['willing_to_participate'].toString() == 'Yes') {
            willingToParticipate++;
          }
          if (value['uses_menstrual_cup'].toString() == 'Yes' ||
              value['uses_cloth_pad'].toString() == 'Yes') {
            totalPadsReduced +=
                int.tryParse(value['disposable_products']?.toString() ?? '0') ??
                    0;
          }
        });

        setState(() {
          _totalParticipants = totalParticipants;
          _willingToParticipate = willingToParticipate;
          _totalPadsReduced = totalPadsReduced;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sustainable Menstruation'),
        backgroundColor: const Color.fromARGB(255, 3, 98, 18),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.05,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 3, 98, 18),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                width: screenWidth,
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total Participants',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      _totalParticipants.toString(),
                      style: TextStyle(
                        fontSize: screenWidth * 0.1,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
                child: const Center(
                  child: MyPieChart(),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: screenHeight * 0.26,
                      margin: EdgeInsets.only(right: screenWidth * 0.015),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 228, 229, 229),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: LineChartWidget(
                        sustainableMenstruationCounts: sustainableMenstruationCounts,
                        monthNames: monthNames,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: screenHeight * 0.12,
                          margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 48, 171, 68),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Willing to be Part of this Challenge',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: screenWidth * 0.01),
                                Text(
                                  _willingToParticipate.toString(),
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.12,
                          margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 48, 171, 68),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Total Number of Sanitary Pads Reduced',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: screenWidth * 0.01),
                                Text(
                                  _totalPadsReduced.toString(),
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
