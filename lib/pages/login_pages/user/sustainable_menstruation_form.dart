import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SustainableMenstruationForm extends StatefulWidget {
  const SustainableMenstruationForm({super.key});

  @override
  _SustainableMenstruationFormState createState() =>
      _SustainableMenstruationFormState();
}

class _SustainableMenstruationFormState
    extends State<SustainableMenstruationForm> {
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _disposableProductsController =
      TextEditingController();
  String? _selectedInstitution;
  String? _selectedCategory;
  String? _usesMenstrualCup; // 'Yes' or 'No'
  String? _usesClothPad; // 'Yes' or 'No'
  String? _usesPlasticPads; // 'Yes' or 'No'
  String? _willingToParticipate; // 'Yes' or 'No'

  // Firebase Realtime Database references
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref('sustainable_menstruation_form');
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

  void _resetForm() {
    _NameController.clear();
    _disposableProductsController.clear();
    setState(() {
      _selectedInstitution = null;
      _selectedCategory = null;
      _usesMenstrualCup = null;
      _usesClothPad = null;
      _usesPlasticPads = null;
      _willingToParticipate = null;
    });
  }

  void _submitForm() {
    if (_selectedInstitution != null &&
        _selectedCategory != null &&
        _NameController.text.isNotEmpty &&
        _usesMenstrualCup != null &&
        _usesClothPad != null &&
        _usesPlasticPads != null &&
        _disposableProductsController.text.isNotEmpty &&
        _willingToParticipate != null) {
      // Collect data and add timestamp in preferred format
      final formData = {
        'institution': _selectedInstitution,
        'category': _selectedCategory,
        'name': _NameController.text,
        'uses_menstrual_cup': _usesMenstrualCup,
        'uses_cloth_pad': _usesClothPad,
        'uses_plastic_pads': _usesPlasticPads,
        'disposable_products': _disposableProductsController.text,
        'willing_to_participate': _willingToParticipate,
        'timestamp': DateTime.now()
            .toIso8601String(), // Add timestamp here in ISO format
      };

      // Save to Firebase Realtime Database
      dbRef.push().set(formData).then((_) {
        _resetForm(); // Reset form fields after submission
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data submitted successfully!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting data: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sustainable Menstruation Challenge')),
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
                'Do you use a menstrual cup?',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Yes'),
                      value: 'Yes',
                      groupValue: _usesMenstrualCup,
                      onChanged: (value) {
                        setState(() {
                          _usesMenstrualCup = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('No'),
                      value: 'No',
                      groupValue: _usesMenstrualCup,
                      onChanged: (value) {
                        setState(() {
                          _usesMenstrualCup = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Text(
                'Do you use reusable cloth pads?',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Yes'),
                      value: 'Yes',
                      groupValue: _usesClothPad,
                      onChanged: (value) {
                        setState(() {
                          _usesClothPad = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('No'),
                      value: 'No',
                      groupValue: _usesClothPad,
                      onChanged: (value) {
                        setState(() {
                          _usesClothPad = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Text(
                'Do you use plastic sanitary pads?',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Yes'),
                      value: 'Yes',
                      groupValue: _usesPlasticPads,
                      onChanged: (value) {
                        setState(() {
                          _usesPlasticPads = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('No'),
                      value: 'No',
                      groupValue: _usesPlasticPads,
                      onChanged: (value) {
                        setState(() {
                          _usesPlasticPads = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _disposableProductsController,
                decoration: InputDecoration(
                    labelText:
                        'How many disposable menstrual products do you discard per month?'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly, // Ensures only digits are allowed
                ],
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
