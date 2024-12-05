import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Opens the drawer
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
      body: const Center(child: Text('Dash Page content')),
    );
  }
}
