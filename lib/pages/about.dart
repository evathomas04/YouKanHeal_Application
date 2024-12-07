import 'package:flutter/material.dart';
import 'drawer.dart'; // Import the reusable drawer

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Center(
          child: Image.asset(
            'assets/logo.png', // Your logo path here
            fit: BoxFit.contain,
            height: 40,
          ),
        ),
      ),
      body: Container(
        color: Colors.lightGreen[100], // Background color
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                title: 'About HEAL Project',
                content:
                    'The HEAL (Health, Environment, Agriculture, and Livelihood) project is a flagship initiative by Kochi Municipal Corporation aimed at promoting better waste management, organic farming, and environmental sustainability.',
              ),
              _buildCard(
                title: 'St. Teresa’s College (Autonomous)',
                content:
                    'St. Teresa’s College has been a leader in empowering women through higher education. The Bhoomitrasena Club promotes environmental awareness and sustainable practices among students.',
              ),
              _buildCard(
                title: 'YouKAN-HEAL Kochi Initiative',
                content:
                    'In collaboration with Kochi Municipal Corporation, GIZ, and St. Teresa’s College, this initiative reduces plastic waste, promotes eco-friendly alternatives, and involves youth in sustainable practices.',
              ),
              _buildCard(
                title: 'Project Objectives',
                content:
                    '• Promote eco-friendly alternatives\n• Encourage reuse and sustainable practices\n• Implement green protocols across educational institutions\n• Empower youth in environmental efforts',
              ),
              _buildCard(
                title: 'Key Actions & Implementation',
                content:
                    'The project includes creating a public dashboard to track challenges, progress, and encourage participants. St. Teresa’s College leads by piloting challenges and coordinating with other institutions to spread sustainable practices.',
              ),
              _buildCard(
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

  Widget _buildCard({required String title, required String content}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
