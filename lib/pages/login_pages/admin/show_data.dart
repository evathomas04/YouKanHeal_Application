import 'package:flutter/material.dart';
import 'data/ban_the_bag_data.dart';
import 'data/sustainable_menstruation_data.dart';
import 'data/green_protocol_data.dart';

class ShowDataPage extends StatelessWidget {
  const ShowDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final List<Map<String, dynamic>> dataPages = [
      {'title': 'Ban the Bag Data', 'page': const BanTheBagDataPage()},
      {
        'title': 'Sustainable Menstruation Data',
        'page': const SustainableMenstruationDataPage()
      },
      {'title': 'Green Protocol Data', 'page': const GreenProtocolDataPage()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Overview',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 19, 147, 43),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: ListView.builder(
          itemCount: dataPages.length,
          itemBuilder: (context, index) {
            final item = dataPages[index];
            return Column(
              children: [
                Card(
                  color: const Color.fromARGB(255, 19, 147, 43),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    title: Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward, color: Colors.white),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => item['page']),
                      );
                    },
                  ),
                ),
                if (index < dataPages.length - 1)
                  const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }

}
