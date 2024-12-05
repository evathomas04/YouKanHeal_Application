import 'package:flutter/material.dart';
import 'pages/about.dart';
import 'pages/challenge.dart';
import 'pages/dashboard.dart';
import 'pages/contact.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Youkan Heal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/about': (context) => AboutPage(),
        '/challenge': (context) => ChallengePage(),
        '/dashboard': (context) => DashboardPage(),
        '/contact': (context) => ContactPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> _onWillPop(BuildContext context) async {
    // Handle the back button press
    Navigator.pop(context); // Go back to the previous page
    return Future.value(false); // Prevent app from closing
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Youkan Heal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.pushNamed(
                      context, '/'); // Use pushNamed for navigation
                },
              ),
              ListTile(
                title: const Text('About'),
                onTap: () {
                  Navigator.pushNamed(
                      context, '/about'); // Use pushNamed for navigation
                },
              ),
              ListTile(
                title: const Text('Challenge'),
                onTap: () {
                  Navigator.pushNamed(
                      context, '/challenge'); // Use pushNamed for navigation
                },
              ),
              ListTile(
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.pushNamed(
                      context, '/dashboard'); // Use pushNamed for navigation
                },
              ),
              ListTile(
                title: const Text('Contact'),
                onTap: () {
                  Navigator.pushNamed(
                      context, '/contact'); // Use pushNamed for navigation
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              if (_scaffoldKey.currentState != null) {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
          title: Center(
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                // Handle account icon click
              },
            ),
          ],
        ),
        body: const Center(
          child: Text('Home Page Content'),
        ),
      ),
    );
  }
}
