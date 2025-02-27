import 'package:flutter/material.dart';
import 'drawer.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});

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
            'assets/logo.png',
            fit: BoxFit.contain,
            height: screenHeight * 0.05, // Responsive height
          ),
        ),
      ),
      body: Container(
        color: Colors.lightGreen[100],
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
          child: ListView(
            children: [
              Card(
                elevation: 5,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Challenges',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06, // Responsive font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02), // Responsive spacing
                      Text(
                        'Below are the different challenges under the YouKAN-HEAL project:',
                        style: TextStyle(fontSize: screenWidth * 0.045), // Responsive font size
                      ),
                    ],
                  ),
                ),
              ),
              _buildExpansionTile(
                context,
                'Green Protocol',
                'The Green Protocol is one of the challenges in the YOUKAN HEAL KOCHI project. '
                    'This initiative was taken to reduce all types of disposals including plastic, paper, etc in our daily life. '
                    'This challenge is implemented in two ways:\n\n'
                    '• Outside college - Volunteers check public functions for green practices.\n'
                    '• Inside college - Ensuring environmentally friendly products are used at college functions.',
              ),
              _buildExpansionTile(
                context,
                'BYC (Bring your Cup)',
                'Encouraging the use of reusable cups/plates/lunchboxes during events.',
              ),
              _buildExpansionTile(
                context,
                'Litter-free challenge',
                'A challenge to clean the surroundings to help reduce mosquitoes and pollution.',
              ),
              _buildExpansionTile(
                context,
                'Ban the bag challenge',
                'Switching from non-biodegradable plastic bags to biodegradable bags. '
                    'Encouraging reusable carry bags for shopping to reduce plastic waste.',
              ),
              _buildExpansionTile(
                context,
                'Sweet Repeats',
                'A challenge to exchange or donate unused, unspoiled items to others, promoting a barter or swap system.',
              ),
              _buildExpansionTile(
                context,
                'Sustainable Menstrual Practices',
                'Encouraging the use of reusable cloth pads instead of disposable ones, reducing sanitary waste.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile(BuildContext context, String title, String content) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth * 0.045, // Responsive font size
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Responsive padding
          child: Text(
            content,
            style: TextStyle(fontSize: screenWidth * 0.04), // Responsive font size
          ),
        ),
        SizedBox(height: screenWidth * 0.03), // Responsive spacing
      ],
    );
  }
}
