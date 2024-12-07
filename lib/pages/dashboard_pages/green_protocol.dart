import 'package:flutter/material.dart';

class GreenProtocol extends StatelessWidget {
  final String message;

  const GreenProtocol({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Protocol'),
        backgroundColor: const Color.fromARGB(
            255, 3, 98, 18), // Set the background color of the AppBar
        titleTextStyle: const TextStyle(
          color: Colors.white, // Set the text color of the AppBar title
          fontSize: 20, // You can also change the font size here
          fontWeight: FontWeight.bold, // Adjust the font weight if needed
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Institution Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Institution',
                  border: OutlineInputBorder(),
                ),
                items: <String>[
                  "St. Teresa's college",
                  'ABC College',
                  'Chinmaya',
                  'Institution 4',
                  'Institution 5'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: 20),
              // Month Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Year',
                  border: OutlineInputBorder(),
                ),
                items: <String>[
                  '2022',
                  '2023',
                  '2024',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),

              const SizedBox(height: 20),
              // Month Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Month',
                  border: OutlineInputBorder(),
                ),
                items: <String>[
                  'January',
                  'February',
                  'March',
                  'April',
                  'May',
                  'June',
                  'July',
                  'August',
                  'September',
                  'October',
                  'November',
                  'December'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),

              const SizedBox(height: 32),
// Total Participants Section with Pie Chart
              Container(
                decoration: BoxDecoration(
                  color:
                  const Color.fromARGB(255, 3, 98, 18), // Background color
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                ),
                width: 375, // Set a fixed width (adjust as needed)
                padding:
                const EdgeInsets.all(16), // Padding inside the container
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Total Participants count
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.center, // Aligns text to the start
                      children: [
                        Text(
                          'Total Participants',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '302', // Replace with dynamic data
                          style: TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Pie Chart
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  width: 375,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 228, 229, 229),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Stat Cards Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Graph (Placeholder for now)
                  Expanded(
                    child: Container(
                      height: 210,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 228, 229, 229),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(Icons.show_chart,
                            size: 60), // Placeholder graph
                      ),
                    ),
                  ),

                  // Stat Cards (Bring your own bag, etc.)
                  Expanded(
                    child: Column(
                      children: [
                        // Bring your own bag card
                        Container(
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 48, 171, 68),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Center horizontally
                              children: [
                                Text(
                                  'Willing to be Part of this Challenge', // First text
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                SizedBox(
                                    height: 8), // Spacing between the texts
                                Text(
                                  '400', // Second text
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Plastic bags reduced card
                        Container(
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 48, 171, 68),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center, // Center vertically
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Center horizontally
                              children: [
                                Text(
                                  'Total Number of Plastic Cups Reduced', // First text
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                                SizedBox(
                                    height: 8), // Spacing between the texts
                                Text(
                                  '320', // Second text
                                  style: TextStyle(
                                      fontSize: 24,
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