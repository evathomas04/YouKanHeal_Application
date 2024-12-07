import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/about.dart';
import 'pages/challenge.dart';
import 'pages/dashboard.dart';
import 'pages/contact.dart';
import 'pages/drawer.dart';
import 'pages/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/': (context) => const HomePage(),
        '/about': (context) => const AboutPage(),
        '/challenge': (context) => const ChallengePage(),
        '/dashboard': (context) => const DashboardPage(),
        '/contact': (context) => const ContactPage(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
            'assets/logo.png',
            fit: BoxFit.contain,
            height: 40,
=======
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
                  color: Color.fromARGB(255, 19, 147, 43),
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
>>>>>>> b0091a2a52994186a7f43ebb007db3863b4b7c4c
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/home_image.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              'YouKAN-HEAL',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 19, 147, 43),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.lightGreen[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Kochi Municipal Corporation, GIZ, C-HED and St. Teresa’s College together will initiate a project in alignment with the LiFE project of Govt. of India, which aims at mobilizing youth for reduction of single-use plastics and promotion of sustainable practices/ecofriendly alternatives. This venture strives to effect solutions to the serious environmental crisis posed by plastic waste also leading to pollution of marine waters. The proactive involvement of children and youth is a critical step required in moulding an environmentally responsible future generation. Imbibing and adopting sustainable practices as part of the daily lifestyle/ routine is expected to lead to embedded behavioral changes in children. The entire task force of children and youth will be brought under the umbrella of the Cochin Corporation for collective action. Students will get an opportunity to claim collective ownership in actions taken towards environmental protection as they partner and work along with the Local Government.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
              child: const Text(
                'Read More',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 19, 147, 43),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
<<<<<<< HEAD
=======
        body: SingleChildScrollView(
          // Wrap the entire body with SingleChildScrollView
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Image after the heading
              Image.asset(
                'assets/home_image.jpg', // Path to your image file
                height: 200, // Adjust size as needed
                width:
                    double.infinity, // Makes image span the width of the screen
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              // Heading - "YouKAN-HEAL"
              const Text(
                'YouKAN-HEAL',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 19, 147, 43),
                ),
              ),
              const SizedBox(height: 20),
              // Home Page Content inside a Container with a light green background
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.lightGreen[100], // Light green background color
                  borderRadius:
                      BorderRadius.circular(8), // Optional rounded corners
                ),
                child: const Text(
                  'Kochi Municipal Corporation, GIZ, C-HED and St. Teresa’s College together will initiate a project in alignment with the LiFE project of Govt. of India, which aims at mobilizing youth for reduction of single-use plastics and promotion of sustainable practices/ecofriendly alternatives. This venture strives to effect solutions to the serious environmental crisis posed by plastic waste also leading to pollution of marine waters. The proactive involvement of children and youth is a critical step required in moulding an environmentally responsible future generation. Imbibing and adopting sustainable practices as part of the daily lifestyle/ routine is expected to lead to embedded behavioral changes in children. The entire task force of children and youth will be brought under the umbrella of the Cochin Corporation for collective action. Students will get an opportunity to claim collective ownership in actions taken towards environmental protection as they partner and work along with the Local Government.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              // "Read More" button with white text
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/about'); // Navigate to About page
                },
                child: const Text(
                  'Read More',
                  style: TextStyle(
                    color: Colors.white, // Change text color to white
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 19, 147, 43), // Button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
>>>>>>> b0091a2a52994186a7f43ebb007db3863b4b7c4c
      ),
    );
  }
}
