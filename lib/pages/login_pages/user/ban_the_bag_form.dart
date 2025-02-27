import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter

class BanTheBagForm extends StatefulWidget {
  const BanTheBagForm({super.key});

  @override
  _BanTheBagFormState createState() => _BanTheBagFormState();
}

class _BanTheBagFormState extends State<BanTheBagForm> {
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _nonBiodegradableBagsController =
      TextEditingController();
  String? _selectedInstitution;
  String? _selectedCategory;
  String? _carryOwnBag; // 'Yes' or 'No'
  String? _willingToParticipate; // 'Yes' or 'No'
  String? _preferenceReason; // Dropdown for preference reason
  String? _reusableBagMaterial; // Dropdown for reusable bag material

  // Firebase Realtime Database reference
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref('ban_the_bag_form');
  final DatabaseReference _institutionsRef =
      FirebaseDatabase.instance.ref('institutions');

  List<String> _institutions = [];

  @override
  void initState() {
    super.initState();
    // Fetch the list of institutions from Firebase
    _fetchInstitutions();
  }

  void _fetchInstitutions() async {
    _institutionsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          _institutions = List<String>.from(data.values);
        });
      }
    });
  }

  void _submitForm() {
    if (_selectedInstitution != null &&
        _selectedCategory != null &&
        _NameController.text.isNotEmpty &&
        _nonBiodegradableBagsController.text.isNotEmpty &&
        _carryOwnBag != null &&
        _willingToParticipate != null &&
        _preferenceReason != null &&
        _reusableBagMaterial != null) {
      // Collect data and add timestamp in preferred format
      final formData = {
        'institution': _selectedInstitution,
        'category': _selectedCategory,
        'name': _NameController.text,
        'non_biodegradable_bags': _nonBiodegradableBagsController.text,
        'carry_own_bag': _carryOwnBag,
        'willing_to_participate': _willingToParticipate,
        'preference_reason': _preferenceReason,
        'reusable_bag_material': _reusableBagMaterial,
        'timestamp':
            DateTime.now().toIso8601String(), // Add timestamp in ISO8601 format
      };

      // Save to Firebase Realtime Database
      dbRef.push().set(formData).then((_) {
        // Show Snackbar with success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data submitted successfully!')),
        );
        _resetForm(); // Reset form fields after submission
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting data: $error')),
        );
      });
    } else {
      // Show Snackbar if any field is missing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  void _resetForm() {
    // Reset form fields after submission
    _NameController.clear();
    _nonBiodegradableBagsController.clear();
    setState(() {
      _selectedInstitution = null;
      _selectedCategory = null;
      _carryOwnBag = null;
      _willingToParticipate = null;
      _preferenceReason = null;
      _reusableBagMaterial = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ban the Bag Challenge')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedInstitution,
                items: _institutions
                    .map((institution) => DropdownMenuItem<String>(
                          value: institution,
                          child: Text(institution),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Institution'),
                onChanged: (value) {
                  setState(() {
                    _selectedInstitution = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['School', 'UG', 'PG', 'Faculty']
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                decoration: InputDecoration(
                    labelText: 'Category (School, UG, PG, Faculty)'),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              TextField(
                controller: _NameController,
                decoration: InputDecoration(labelText: 'Enter your full name'),
              ),
              SizedBox(height: 20),
              Text(
                'Do you and your family always carry your own bag whenever you go for shopping?',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Yes'),
                      value: 'Yes',
                      groupValue: _carryOwnBag,
                      onChanged: (value) {
                        setState(() {
                          _carryOwnBag = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('No'),
                      value: 'No',
                      groupValue: _carryOwnBag,
                      onChanged: (value) {
                        setState(() {
                          _carryOwnBag = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _nonBiodegradableBagsController,
                decoration: InputDecoration(
                    labelText:
                        'Number of non-biodegradable bags brought (if any)'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Only digits allowed
                ],
              ),
              DropdownButtonFormField<String>(
                value: _reusableBagMaterial,
                items: ['Cloth', 'Jute', 'Paper', 'Plastic', 'Other']
                    .map((material) => DropdownMenuItem<String>(
                          value: material,
                          child: Text(material),
                        ))
                    .toList(),
                decoration:
                    InputDecoration(labelText: 'Material of Reusable Bag'),
                onChanged: (value) {
                  setState(() {
                    _reusableBagMaterial = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _preferenceReason,
                items: [
                  'Cost',
                  'Availability',
                  'Durability',
                  'Eco-friendliness',
                  'Other'
                ]
                    .map((reason) => DropdownMenuItem<String>(
                          value: reason,
                          child: Text(reason),
                        ))
                    .toList(),
                decoration: InputDecoration(
                    labelText: 'Why do you prefer this type of bag?'),
                onChanged: (value) {
                  setState(() {
                    _preferenceReason = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                'Are you willing to be part of this challenge?',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Yes'),
                      value: 'Yes',
                      groupValue: _willingToParticipate,
                      onChanged: (value) {
                        setState(() {
                          _willingToParticipate = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('No'),
                      value: 'No',
                      groupValue: _willingToParticipate,
                      onChanged: (value) {
                        setState(() {
                          _willingToParticipate = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
