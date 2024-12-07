import 'package:flutter/material.dart';
import 'dashboard_pages/ban_the_bag.dart';
import 'dashboard_pages/green_protocol.dart';
import 'dashboard_pages/sustainable_menstruation.dart';
import 'drawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedType = 'All'; // Default filter value

  // Example institution data
  final List<Map<String, String>> institutions = [
    {
      'type': 'college',
      'logo': 'assets/college_logo.png',
      'name': 'St Teresas College',
      'place': 'Ernakulam',
      'value': '1600',
      'date': 'May 2024',
    },
    {
      'type': 'school',
      'logo': 'assets/school_logo.png',
      'name': 'Chinmaya',
      'place': 'Ernakulam',
      'value': '1000',
      'date': 'Aug 2024',
    },
    {
      'type': 'college',
      'logo': 'assets/college_logo.png',
      'name': 'ABC College',
      'place': 'location',
      'value': '100',
      'date': 'Jul 2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Challenge Dashboard',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildDashboardCard(context, 'Total Number of Participants', '300'),
            _buildCategorySection(context),
            _buildInstitutionList(context),
            _buildClickableBoxes(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: 375,
        height: 200,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 3, 98, 18),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Statistics',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: 375,
            height: 225,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 228, 229, 229),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Institutions',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstitutionList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: 375,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: <Widget>[
            // Institution Filter Options
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: DropdownButton<String>(
                value: selectedType,
                icon: const Icon(Icons.filter_list),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue!;
                  });
                },
                items: <String>['All', 'College', 'School']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            // Display the filtered institution list
            for (var institution in institutions.where((institution) {
              if (selectedType == 'All') {
                return true;
              }
              return institution['type'] == selectedType.toLowerCase();
            }))
              ListTile(
                leading: Image.asset(institution['logo']!),
                title: Text(institution['name']!),
                subtitle:
                    Text('${institution['place']} - ${institution['date']}'),
                trailing: Text(institution['value']!),
                onTap: () {
                  // Handle item click if needed
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableBoxes(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildClickableBox(
          context,
          'Green Protocol',
          'assets/green.png',
          GreenProtocol(message: 'Hello 1'),
        ),
        const SizedBox(height: 20),
        _buildClickableBox(
          context,
          'Sustainable Menstruation',
          'assets/sustainable_mensuration.png',
          SustainableMensuration(message: 'Hello 2'),
        ),
        const SizedBox(height: 20),
        _buildClickableBox(
          context,
          'Ban The Bag',
          'assets/ban_the_bag.png',
          BanTheBag(message: 'Hello 3'),
        ),
      ],
    );
  }

  Widget _buildClickableBox(
      BuildContext context, String title, String imagePath, Widget nextPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => nextPage,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: 375,
          height: 200,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 3, 98, 18),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  imagePath,
                  height: 40,
                  width: 40,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
