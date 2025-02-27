import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ban_the_bag_form.dart';
import 'sustainable_menstruation_form.dart';
import 'green_protocol_form.dart';

class UserLogin extends StatelessWidget {
  const UserLogin({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Center(child: CircularProgressIndicator());
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isLargeScreen = screenWidth > 600; // Adjust layout for tablets

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Challenge'),
        backgroundColor: const Color.fromARGB(255, 3, 98, 18),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(isLargeScreen ? 32.0 : 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChallengeButton(
                  context, 'Ban the Bag Challenge', BanTheBagForm(), screenWidth),
              SizedBox(height: isLargeScreen ? 24 : 16),
              _buildChallengeButton(
                  context, 'Green Protocol Challenge', GreenProtocolForm(), screenWidth),
              SizedBox(height: isLargeScreen ? 24 : 16),
              _buildChallengeButton(
                  context,
                  'Sustainable Menstruation Challenge',
                  SustainableMenstruationForm(),
                  screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeButton(
      BuildContext context, String text, Widget nextPage, double screenWidth) {
    return SizedBox(
      width: screenWidth * 1, // Adjust button width based on screen size
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 3, 98, 18),
          padding: EdgeInsets.symmetric(vertical: screenWidth > 600 ? 20 : 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: screenWidth > 600 ? 20 : 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}
