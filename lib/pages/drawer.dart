import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text(
              'YouKAN-HEAL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildDrawerItem(context, 'Home', '/'),
          _buildDrawerItem(context, 'About', '/about'),
          _buildDrawerItem(context, 'Challenge', '/challenge'),
          _buildDrawerItem(context, 'Dashboard', '/dashboard'),
          _buildDrawerItem(context, 'Contact', '/contact'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
