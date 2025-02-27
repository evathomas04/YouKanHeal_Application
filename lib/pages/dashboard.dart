

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'line_chart.dart';
import 'dashboard_pages/ban_the_bag.dart';
import 'dashboard_pages/green_protocol.dart';
import 'dashboard_pages/sustainable_menstruation.dart';
import 'drawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DatabaseReference _banTheBagRef =
  FirebaseDatabase.instance.ref('ban_the_bag_form');
  final DatabaseReference _sustainableMenstruationRef =
  FirebaseDatabase.instance.ref('sustainable_menstruation_form');
  final DatabaseReference _institutionsRef =
  FirebaseDatabase.instance.ref('institutions');

  List<double> banTheBagCounts = List.filled(7, 0); // For the last 7 months
  List<double> sustainableMenstruationCounts =
  List.filled(7, 0); // For the last 7 months
  List<String> monthNames = []; // To hold month names for x-axis
  List<String> institutions = [];

  @override
  void initState() {
    super.initState();
    initializeMonthNames();
    fetchData(); // Fetch data after initializing month names
    fetchInstitutions();
  }

  // Initialize month names for the last 7 months
  void initializeMonthNames() {
    DateTime now = DateTime.now();
    monthNames = List.generate(7, (index) {
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
              if (monthIndex >= 0 && monthIndex < 7) {
                banTheBagCounts[6 - monthIndex]++;
              }
            }
          }
        }
        setState(() {});
      } else {
        print('No Ban The Bag data available.');
      }
    });

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
              if (monthIndex >= 0 && monthIndex < 7) {
                sustainableMenstruationCounts[6 - monthIndex]++;
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

  // Fetch institution names from Firebase
  void fetchInstitutions() {
    _institutionsRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
        event.snapshot.value as Map<dynamic, dynamic>;
        institutions =
        List<String>.from(data.entries.map((entry) => entry.value ?? ''));

        setState(() {});
      } else {
        print('No institutions data available.');
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
    sustainableMenstruationCounts.fillRange(
        0, sustainableMenstruationCounts.length, 0);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Center(
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
            height: screenHeight * 0.05, // Adjusted height
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: screenHeight * 0.025),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Text(
                'Challenge Dashboard',
                style: TextStyle(
                  fontSize: screenWidth * 0.06, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildDashboardCard(
              context,
              "Total Number of Participants",
              '${banTheBagCounts.reduce((a, b) => a + b).toInt() + sustainableMenstruationCounts.reduce((a, b) => a + b).toInt()}',
            ),
            _buildCategorySection(context),
            LineChartWidget(
              banTheBagCounts: banTheBagCounts,
              sustainableMenstruationCounts: sustainableMenstruationCounts,
              monthNames: monthNames,
            ),
            _buildInstitutionList(context),
            _buildClickableBoxes(context),
          ],
        ),
      ),
    );
  }

// Responsive Dashboard Card
  Widget _buildDashboardCard(BuildContext context, String title, String value) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Container(
        width: screenWidth * 0.9, // 90% of screen width
        height: screenHeight * 0.2, // 20% of screen height
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 3, 98, 18),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.04, // Scales dynamically
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.08, // Scales dynamically
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Responsive Institution List
  Widget _buildInstitutionList(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.025),
          Text(
            'Institutions',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          Container(
            height: screenHeight * 0.3, // 40% of screen height
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: institutions.isEmpty
                ? const Center(child: Text("No institutions available"))
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: institutions.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.025),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.04,
                    ),
                    title: Row(
                      children: [
                        Text(
                          '${index + 1}. ',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            institutions[index],
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.school,
                          color: Color.fromARGB(255, 3, 98, 18),
                          size: screenWidth * 0.05,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

// Responsive Category Section
  Widget _buildCategorySection(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        SizedBox(height: screenHeight * 0.025),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Text(
            'Current Impact',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.015),
      ],
    );
  }

  Widget _buildClickableBoxes(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04, vertical: screenHeight * 0.025),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.025), // Responsive spacing
          Text(
            'Explore Challenges',
            style: TextStyle(
                fontSize: screenWidth * 0.05, // Responsive font size
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          SizedBox(height: screenHeight * 0.015),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: _buildClickableBox(
                      context,
                      'Green Protocol',
                      'assets/green.png',
                      const GreenProtocol(message: 'Hello1')),
                ),
                SizedBox(width: screenWidth * 0.02), // Reduced spacing
                Flexible(
                  child: _buildClickableBox(
                      context,
                      'Sustainable Menstruation',
                      'assets/sustainable_mensuration.png',
                      const SustainableMenstruation(message: 'Hello2')),
                ),
                SizedBox(width: screenWidth * 0.02),
                Flexible(
                  child: _buildClickableBox(
                      context,
                      'Ban the Bag',
                      'assets/ban_the_bag.png',
                      const BanTheBag(message: 'Hello3')),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.025),
        ],
      ),
    );
  }

// Single clickable box
  Widget _buildClickableBox(
      BuildContext context, String title, String imagePath, Widget page) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        width: screenWidth * 0.3, // Responsive width
        height: screenHeight * 0.18, // Responsive height
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.04), // Responsive border radius
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: screenWidth * 0.12), // Responsive image size
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenWidth * 0.03, // Responsive text size
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
        ),
      ),
    );
  }
}