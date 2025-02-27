import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text(
              'YouKan Heal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(color: Colors.green),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () => Navigator.pushNamed(context, '/'),
          ),
          ListTile(
            title: const Text('About'),
            onTap: () => Navigator.pushNamed(context, '/about'),
          ),
          ListTile(
            title: const Text('Challenge'),
            onTap: () => Navigator.pushNamed(context, '/challenge'),
          ),
          ListTile(
            title: const Text('Dashboard'),
            onTap: () => Navigator.pushNamed(context, '/dashboard'),
          ),
          ListTile(
            title: const Text('Contact'),
            onTap: () => Navigator.pushNamed(context, '/contact'),
          ),
          ListTile(
            title: const Text('Add Data'),
            onTap: () async {
              User? currentUser = FirebaseAuth.instance.currentUser;

              if (currentUser == null) {
                // User is not logged in
                Navigator.pushNamed(context, '/login');
              } else if (currentUser.email == "youkanhealofficial@gmail.com") {
                // Admin is logged in
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Action Restricted"),
                    content: const Text(
                        "You need to log out as admin and log in as a user to add data."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              } else {
                // Regular user is logged in
                Navigator.pushNamed(context, '/user_login');
              }
            },
          ),
        ],
      ),
    );
  }
}
