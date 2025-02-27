import 'package:flutter/material.dart';
import 'drawer.dart'; // Import the reusable drawer

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Center(
          child: Image.asset(
            'assets/logo.png', // Your logo path here
            fit: BoxFit.contain,
            height: screenHeight * 0.05,
          ),
        ),
      ),
      body: Container(
        color: Colors.lightGreen[100], // Background color
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05), // Adjusted padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                context: context,
                title: 'About HEAL Project',
                content:
                'The HEAL (Health, Environment, Agriculture, and Livelihood) project is a flagship initiative by Kochi Municipal Corporation aimed at promoting better waste management, organic farming, and environmental sustainability.',
              ),
              _buildCard(
                context: context,
                title: 'St. Teresa’s College (Autonomous)',
                content:
                'St. Teresa’s College has been a leader in empowering women through higher education. The Bhoomitrasena Club promotes environmental awareness and sustainable practices among students.',
              ),
              _buildCard(
                context: context,
                title: 'YouKAN-HEAL Kochi Initiative',
                content:
                'In collaboration with Kochi Municipal Corporation, GIZ, and St. Teresa’s College, this initiative reduces plastic waste, promotes eco-friendly alternatives, and involves youth in sustainable practices.',
              ),
              _buildCard(
                context: context,
                title: 'Project Objectives',
                content:
                '• Promote eco-friendly alternatives\n• Encourage reuse and sustainable practices\n• Implement green protocols across educational institutions\n• Empower youth in environmental efforts',
              ),
              _buildCard(
                context: context,
                title: 'Key Actions & Implementation',
                content:
                'The project includes creating a public dashboard to track challenges, progress, and encourage participants. St. Teresa’s College leads by piloting challenges and coordinating with other institutions to spread sustainable practices.',
              ),
              _buildCard(
                context: context,
                title: 'Evaluation and Recognition',
                content:
                'Institutions will submit reports on their sustainability efforts, and the best-performing schools and colleges will be recognized with awards during the next Environment Day celebration.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.04), // Adjusted margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03), // Responsive border radius
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.05, // Responsive font size
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: screenWidth * 0.02), // Responsive spacing
            Text(
              content,
              style: TextStyle(
                fontSize: screenWidth * 0.045, // Responsive font size
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
