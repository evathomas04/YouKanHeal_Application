import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'charts/piechart_greenprot.dart';
import 'package:youkanheal_mainproject/pages/dashboard_pages/charts/linechart_greenprot.dart';

class GreenProtocol extends StatefulWidget {
  final String message;

  const GreenProtocol({super.key, required this.message});

  @override
  _GreenProtocolState createState() => _GreenProtocolState();
}

class _GreenProtocolState extends State<GreenProtocol> {
  final DatabaseReference _greenProtocolRef =
  FirebaseDatabase.instance.ref('green_protocol_form');
  List<double> greenProtocolCounts = List.filled(3, 0); // For the last 3 months
  List<String> monthNames = [];
  int totalParticipants = 0;
  int numberOfEvents = 0;
  int totalItemsAvoided = 0;

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

  /// Parse a date string in the format mm-dd-yyyy
  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      List<String> parts = dateStr.split('-');
      if (parts.length == 3) {
        int month = int.parse(parts[0]);
        int day = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      print("Error parsing date: $e");
    }
    return null;
  }

  void resetCounts() {
    greenProtocolCounts.fillRange(0, greenProtocolCounts.length, 0);
  }

  void _initializeListeners() {
    _greenProtocolRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
        event.snapshot.value as Map<dynamic, dynamic>;

        resetCounts();
        DateTime now = DateTime.now();

        // Process data for line chart counts
        for (var entry in data.entries) {
          String? dateStr = entry.value['event_date'];
          DateTime? eventDate = _parseDate(dateStr);
          if (eventDate != null) {
            int monthIndex = (now.year - eventDate.year) * 12 +
                now.month -
                eventDate.month;

            if (monthIndex >= 0 && monthIndex < 3) {
              greenProtocolCounts[2 - monthIndex]++;
            }
          }
        }

        // Process data for stats (total events, participants, and items avoided)
        int participants = 0;
        int itemsAvoided = 0;

        for (var entry in data.entries) {
          int participantsForEvent = 0;

          if (entry.value['number_of_participants'] is int) {
            participantsForEvent = entry.value['number_of_participants'];
          } else if (entry.value['number_of_participants'] is String) {
            participantsForEvent =
                int.tryParse(entry.value['number_of_participants']) ?? 0;
          }

          participants += participantsForEvent;

          List<String> itemsUsed = [];
          if (entry.value['items_used'] is List) {
            itemsUsed = List<String>.from(entry.value['items_used']);
          }

          itemsAvoided += participantsForEvent * itemsUsed.length;
        }

        setState(() {
          numberOfEvents = data.length;
          totalParticipants = participants;
          totalItemsAvoided = itemsAvoided;
        });
      } else {
        print('No Green Protocol data available.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initializeMonthNames();
    _initializeListeners();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Protocol'),
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
                width: screenWidth * 1,
                padding: EdgeInsets.all(screenWidth * 0.03),
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
                          '$totalParticipants',
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
                      margin: EdgeInsets.only(right: screenWidth * 0.015),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 228, 229, 229),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: LineChartWidget(
                        greenProtocolCounts: greenProtocolCounts,
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
                                  'Total Number of Events',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: screenWidth * 0.01),
                                Text(
                                  '$numberOfEvents',
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
                                  'Total Number of Disposable Items Avoided',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: screenWidth * 0.01),
                                Text(
                                  '$totalItemsAvoided',
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
