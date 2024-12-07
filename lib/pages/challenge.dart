import 'package:flutter/material.dart';
import 'drawer.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
<<<<<<< HEAD
      key: _scaffoldKey,
      drawer: const AppDrawer(),
=======
>>>>>>> b0091a2a52994186a7f43ebb007db3863b4b7c4c
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
<<<<<<< HEAD
            _scaffoldKey.currentState?.openDrawer();
=======
            Scaffold.of(context).openDrawer(); // Opens the drawer
>>>>>>> b0091a2a52994186a7f43ebb007db3863b4b7c4c
          },
        ),
        title: Center(
          child: Image.asset(
<<<<<<< HEAD
            'assets/logo.png',
=======
            'assets/logo.png', // Your logo path here
>>>>>>> b0091a2a52994186a7f43ebb007db3863b4b7c4c
            fit: BoxFit.contain,
            height: 40,
          ),
        ),
      ),
<<<<<<< HEAD
      body: Container(
        color: Colors.lightGreen[100],
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: ListView(
            children: [
              Card(
                elevation: 5,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Challenges',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Below are the different challenges under the YouKAN-HEAL project:',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              _buildExpansionTile(
                'Green Protocol',
                'The Green Protocol is one of the challenges in the YOUKAN HEAL KOCHI project. '
                    'This initiative was taken to reduce all types of disposals including plastic, paper, etc in our daily life. '
                    'This challenge is implemented in two ways:\n\n'
                    '• Outside college - Volunteers check public functions for green practices.\n'
                    '• Inside college - Ensuring environmentally friendly products are used at college functions.',
              ),
              _buildExpansionTile(
                'BYC (Bring your Cup)',
                'Encouraging the use of reusable cups/plates/lunchboxes during events.',
              ),
              _buildExpansionTile(
                'Litter-free challenge',
                'A challenge to clean the surroundings to help reduce mosquitoes and pollution.',
              ),
              _buildExpansionTile(
                'Ban the bag challenge',
                'Switching from non-biodegradable plastic bags to biodegradable bags. '
                    'Encouraging reusable carry bags for shopping to reduce plastic waste.',
              ),
              _buildExpansionTile(
                'Sweet Repeats',
                'A challenge to exchange or donate unused, unspoiled items to others, promoting a barter or swap system.',
              ),
              _buildExpansionTile(
                'Sustainable Menstrual Practices',
                'Encouraging the use of reusable cloth pads instead of disposable ones, reducing sanitary waste.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, String content) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      children: [
        ListTile(
          title: Text(content),
        ),
      ],
=======
      body: const Center(child: Text('Challenge Page content')),
>>>>>>> b0091a2a52994186a7f43ebb007db3863b4b7c4c
    );
  }
}
