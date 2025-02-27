import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'charts/piechart_banbag.dart';
import 'package:youkanheal_mainproject/pages/dashboard_pages/charts/linechart_banbag.dart';

class BanTheBag extends StatefulWidget {
  final String message;

  const BanTheBag({super.key, required this.message});

  @override
  _BanTheBagState createState() => _BanTheBagState();
}

class _BanTheBagState extends State<BanTheBag> {
  final DatabaseReference _banTheBagRef =
  FirebaseDatabase.instance.ref('ban_the_bag_form');
  // late DatabaseReference _institutionsReference;
  // List<String> institutionList = [];

  List<double> banTheBagCounts = List.filled(3, 0); // For the last 3 months
  List<String> monthNames = []; // To hold month names for x-axis

  int totalParticipants = 0;
  int willingToParticipate = 0;
  int bagsAvoided = 0;

  @override
  void initState() {
    super.initState();
    _initializeListeners();
    initializeMonthNames();
    fetchData(); // Fetch data after initializing month names
  }

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

  void fetchData() {
    resetCounts(); // Reset counts before starting any processing

    DateTime now = DateTime.now();

    _banTheBagRef.onValue.listen((DatabaseEvent event) {
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
                banTheBagCounts[2 - monthIndex]++;
              }
            }
          }
        }
        setState(() {});
      } else {
        print('No Ban The Bag data available.');
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
    banTheBagCounts.fillRange(0, banTheBagCounts.length, 0);
  }

  // _institutionsReference = FirebaseDatabase.instance.ref('institutions');

  // // Fetch institution list
  // _institutionsReference.onValue.listen((event) {
  //   final data = event.snapshot.value as Map?;

  //   if (data != null) {
  //     setState(() {
  //       institutionList = List<String>.from(data.values);
  //     });
  //   }
  // });

  // Listen for changes in the data

  void _initializeListeners() {
    _banTheBagRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;

      if (data != null) {
        totalParticipants = data.length;
        int willingCount = 0;
        int bagsCount = 0;

        data.forEach((key, value) {
          if (value is Map) {
            if (value['willing_to_participate'] == 'Yes') {
              willingCount++;
            }

            var bagsValue = value['non_biodegradable_bags'];
            if (bagsValue != null) {
              if (bagsValue is int) {
                bagsCount += bagsValue;
              } else if (bagsValue is double) {
                bagsCount += bagsValue.toInt();
              } else if (bagsValue is String) {
                bagsCount += int.tryParse(bagsValue) ?? 0;
              }
            }
          }
        });

        setState(() {
          willingToParticipate = willingCount;
          bagsAvoided = bagsCount;
        });
      } else {
        setState(() {
          totalParticipants = 0;
          willingToParticipate = 0;
          bagsAvoided = 0;
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
        title: const Text('Ban The Bag'),
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
              // DropdownButtonFormField<String>(
              //   decoration: const InputDecoration(
              //     labelText: 'Select Institution',
              //     border: OutlineInputBorder(),
              //   ),
              //   items: institutionList.map((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              //   onChanged: (_) {},
              // ),
              // const SizedBox(height: 20),
              // DropdownButtonFormField<String>(
              //   decoration: const InputDecoration(
              //     labelText: 'Select Year',
              //     border: OutlineInputBorder(),
              //   ),
              //   items: <String>['2022', '2023', '2024'].map((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              //   onChanged: (_) {},
              // ),
              // const SizedBox(height: 20),
              // DropdownButtonFormField<String>(
              //   decoration: const InputDecoration(
              //     labelText: 'Select Month',
              //     border: OutlineInputBorder(),
              //   ),
              //   items: <String>[
              //     'January',
              //     'February',
              //     'March',
              //     'April',
              //     'May',
              //     'June',
              //     'July',
              //     'August',
              //     'September',
              //     'October',
              //     'November',
              //     'December'
              //   ].map((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              //   onChanged: (_) {},
              // ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 3, 98, 18),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                width: screenWidth * 1,
                padding:  EdgeInsets.all(screenWidth * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
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
                          totalParticipants.toString(),
                          style: TextStyle(
                            fontSize: screenWidth * 0.1,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
                      margin:  EdgeInsets.only(right: screenWidth * 0.015),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 228, 229, 229),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: LineChartWidget(
                        banTheBagCounts:
                        banTheBagCounts, // Pass the data for the last 3 months
                        monthNames: monthNames,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: screenHeight * 0.12,
                          margin:  EdgeInsets.only(bottom: screenHeight * 0.01),
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
                                      fontSize: screenWidth * 0.035, color: Colors.white),
                                ),
                                 SizedBox(height: screenWidth * 0.01),
                                Text(
                                  willingToParticipate.toString(),
                                  style:  TextStyle(
                                      fontSize: screenWidth * 0.06,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.12,
                          margin:  EdgeInsets.only(bottom: screenHeight * 0.01),
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
                                  'Plastic Bags Avoided',
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.035, color: Colors.white),
                                ),
                                 SizedBox(height: screenWidth * 0.01),
                                Text(
                                  bagsAvoided.toString(),
                                  style:  TextStyle(
                                      fontSize: screenWidth * 0.06,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
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