import 'package:flutter/material.dart';
import 'drawer.dart'; // Import the reusable drawer

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
<<<<<<< HEAD
      key: _scaffoldKey,
      drawer: const AppDrawer(), // Use the reusable drawer
=======
>>>>>>> b0091a2a52994186a7f43ebb007db3863b4b7c4c
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
<<<<<<< HEAD
            _scaffoldKey.currentState?.openDrawer(); // Opens the drawer
=======
            Scaffold.of(context).openDrawer(); // Opens the drawer
>>>>>>> b0091a2a52994186a7f43ebb007db3863b4b7c4c
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
<<<<<<< HEAD
      body: Center(
        child: Card(
          elevation: 5,
          color: Colors.lightGreen[100],
          margin: const EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center content horizontally
              children: [
                Text(
                  'Contact Us',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF006400), // Dark green color
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'For inquiries, please reach us at:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 3, 98, 18), // Dark green
                  ),
                  onPressed: () {
                    // Handle button press
                  },
                  child: Text(
                    'Get in Touch',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
=======
      body: const Center(child: Text('Contact Page content')),
>>>>>>> b0091a2a52994186a7f43ebb007db3863b4b7c4c
    );
  }
}
