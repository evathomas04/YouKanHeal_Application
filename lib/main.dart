import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'pages/about.dart';
import 'pages/challenge.dart';
import 'pages/dashboard.dart';
import 'pages/contact.dart';
import 'pages/drawer.dart';
import 'pages/login_screen.dart';
import 'pages/login_pages/user/user_login.dart';
import 'pages/login_pages/admin/admin_login.dart';
import 'package:permission_handler/permission_handler.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  await _requestPermission();
  runApp(const MyApp());
}
Future<void> _requestPermission() async {
  await Permission.storage.request();
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
        '/user_login': (context) => const UserLogin(),
        '/admin_login': (context) => const AdminLogin(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

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
            height: screenWidth * 0.1, // Responsive logo size
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () async {
              User? currentUser = FirebaseAuth.instance.currentUser;

              if (currentUser != null) {
                final bool isAdmin = await _isAdmin(currentUser);
                if (isAdmin) {
                  Navigator.pushNamed(context, '/admin_login');
                } else {
                  Navigator.pushNamed(context, '/user_login');
                }
              } else {
                Navigator.pushNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
        child: Column(
          children: [
            Image.asset(
              'assets/home_image.jpg',
              height: screenWidth * 0.5, // Responsive image height
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: screenWidth * 0.05),
            Text(
              'YouKAN-HEAL',
              style: TextStyle(
                fontSize: screenWidth * 0.07, // Responsive font size
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 19, 147, 43),
              ),
            ),
            SizedBox(height: screenWidth * 0.05),
            Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: Colors.lightGreen[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Kochi Municipal Corporation, GIZ, C-HED and St. Teresa’s College together will initiate a project in alignment with the LiFE project of Govt. of India, which aims at mobilizing youth for reduction of single-use plastics and promotion of sustainable practices/ecofriendly alternatives. This venture strives to effect solutions to the serious environmental crisis posed by plastic waste also leading to pollution of marine waters. The proactive involvement of children and youth is a critical step required in moulding an environmentally responsible future generation. Imbibing and adopting sustainable practices as part of the daily lifestyle/ routine is expected to lead to embedded behavioral changes in children. The entire task force of children and youth will be brought under the umbrella of the Cochin Corporation for collective action. Students will get an opportunity to claim collective ownership in actions taken towards environmental protection as they partner and work along with the Local Government.',
                style: TextStyle(fontSize: screenWidth * 0.045), // Responsive text size
              ),
            ),
            SizedBox(height: screenWidth * 0.05),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 19, 147, 43),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1,
                  vertical: screenWidth * 0.03,
                ),
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text(
                'Read More',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _isAdmin(User user) async {
    // Replace this mock implementation with your actual logic
    // Example: Fetch admin flag from Firestore or check custom claims
    String email = user.email ?? "";
    return email == "youkanhealofficial@gmail.com"; // Admin-specific email
  }
}
