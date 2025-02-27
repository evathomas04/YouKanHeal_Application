import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddInstitutionsPage extends StatefulWidget {
  const AddInstitutionsPage({super.key});

  @override
  _AddInstitutionsState createState() => _AddInstitutionsState();
}

class _AddInstitutionsState extends State<AddInstitutionsPage> {
  final TextEditingController _institutionController = TextEditingController();
  final DatabaseReference _institutionsRef =
      FirebaseDatabase.instance.ref('institutions');

  Map<String, String> _institutions = {}; // Store institution keys and names

  @override
  void initState() {
    super.initState();
    _fetchInstitutions();
  }

  void _fetchInstitutions() {
    _institutionsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null && mounted) {
        // Check if the widget is still mounted
        setState(() {
          _institutions = data
              .map((key, value) => MapEntry(key as String, value.toString()));
        });
      }
    });
  }

  void _addInstitution() {
    final institutionName = _institutionController.text.trim();
    if (institutionName.isNotEmpty) {
      _institutionsRef.push().set(institutionName).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Institution added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _institutionController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding institution: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  void _deleteInstitution(String key) {
    _institutionsRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Institution deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting institution: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.05;
    final double fontSize = screenWidth * 0.04;
    final double buttonHeight = screenHeight * 0.06;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Institutions'),
        backgroundColor: Color.fromARGB(255, 19, 147, 43),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _institutionController,
                decoration: InputDecoration(
                  labelText: 'Institution Name',
                  labelStyle: TextStyle(fontSize: fontSize * 0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.school,
                      color: Color.fromARGB(255, 19, 147, 43)),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: _addInstitution,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 19, 147, 43),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Add Institution',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Institutions',
              style: TextStyle(
                fontSize: fontSize * 1.1,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 19, 147, 43),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: _institutions.length,
                  itemBuilder: (context, index) {
                    final key = _institutions.keys.elementAt(index);
                    final institutionName = _institutions[key]!;
                    return ListTile(
                      title: Text(
                        institutionName,
                        style: TextStyle(fontSize: fontSize * 0.9),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteInstitution(key),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
