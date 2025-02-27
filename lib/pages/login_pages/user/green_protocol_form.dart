import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class GreenProtocolForm extends StatefulWidget {
  const GreenProtocolForm({super.key});

  @override
  _GreenProtocolFormState createState() => _GreenProtocolFormState();
}

class _GreenProtocolFormState extends State<GreenProtocolForm> {
  final TextEditingController _volunteerNameController =
      TextEditingController();
  final TextEditingController _departmentNameController =
      TextEditingController();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _numberOfParticipantsController =
      TextEditingController();

  String? _selectedInstitution;
  String? _selectedInstituteType;
  DateTime? _selectedEventDate;
  List<String> _institutions = [];
  final List<String> _selectedItems = [];

  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref('green_protocol_form');
  final DatabaseReference _institutionsRef =
      FirebaseDatabase.instance.ref('institutions');

  @override
  void initState() {
    super.initState();
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

  void _pickEventDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedEventDate = pickedDate;
      });
    }
  }

  void _resetForm() {
    _volunteerNameController.clear();
    _departmentNameController.clear();
    _eventNameController.clear();
    _numberOfParticipantsController.clear();
    setState(() {
      _selectedInstitution = null;
      _selectedInstituteType = null;
      _selectedEventDate = null;
      _selectedItems.clear();
    });
  }

  void _submitForm() async {
    if (_selectedInstitution != null &&
        _selectedInstituteType != null &&
        _volunteerNameController.text.isNotEmpty &&
        _departmentNameController.text.isNotEmpty &&
        _eventNameController.text.isNotEmpty &&
        _selectedEventDate != null &&
        _numberOfParticipantsController.text.isNotEmpty) {
      // Check for existing institution and event name combination
      bool isDuplicate = await _checkForDuplicateEntry();

      if (isDuplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event details were already submitted.')),
        );
        return; // Prevent form submission
      }

      final formData = {
        'institution': _selectedInstitution,
        'institution_type': _selectedInstituteType,
        'volunteer_name': _volunteerNameController.text,
        'department_name': _departmentNameController.text,
        'event_name': _eventNameController.text,
        'event_date': DateFormat('dd-MM-yyyy').format(_selectedEventDate!),
        'items_used': _selectedItems,
        'number_of_participants': _numberOfParticipantsController.text,
      };

      dbRef.push().set(formData).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data submitted successfully!')),
        );
        _resetForm(); // Reset the form after successful submission
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

  Future<bool> _checkForDuplicateEntry() async {
    final querySnapshot = await dbRef
        .orderByChild('event_name')
        .equalTo(_eventNameController.text)
        .once();
    final data = querySnapshot.snapshot.value as Map?;

    if (data != null) {
      // Loop through the results to check if the combination of institution and event name exists
      for (var entry in data.values) {
        if (entry['institution'] == _selectedInstitution) {
          return true; // Duplicate found
        }
      }
    }

    return false; // No duplicates found
  }

  Widget _buildCheckboxTile(String title) {
    return CheckboxListTile(
      title: Text(title),
      value: _selectedItems.contains(title),
      onChanged: (value) {
        setState(() {
          value == true
              ? _selectedItems.add(title)
              : _selectedItems.remove(title);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Green Protocol Challenge')),
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
                value: _selectedInstituteType,
                items: ['School', 'College']
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Type of Institute'),
                onChanged: (value) {
                  setState(() {
                    _selectedInstituteType = value;
                  });
                },
              ),
              TextField(
                controller: _volunteerNameController,
                decoration: InputDecoration(
                    labelText: 'Name of Event Volunteer/Faculty'),
              ),
              TextField(
                controller: _departmentNameController,
                decoration: InputDecoration(labelText: 'Department Name'),
              ),
              TextField(
                controller: _eventNameController,
                decoration: InputDecoration(labelText: 'Event Name'),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedEventDate == null
                        ? 'Select Event Date'
                        : 'Event Date: ${DateFormat('dd-MM-yyyy').format(_selectedEventDate!)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: _pickEventDate,
                    child: Text('Pick Date'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text('Items Used:', style: TextStyle(fontSize: 16)),
              Column(
                children: [
                  _buildCheckboxTile('Reusable Glass'),
                  _buildCheckboxTile('Reusable Plates'),
                  _buildCheckboxTile('Reusable Spoon'),
                  _buildCheckboxTile('Reusable Bowls'),
                  _buildCheckboxTile('Nature Friendly Decorations'),
                  _buildCheckboxTile('Edible Cutlery'),
                  _buildCheckboxTile('Eco Friendly Banner'),
                  _buildCheckboxTile('Eco Friendly Bags'),
                ],
              ),
              TextField(
                controller: _numberOfParticipantsController,
                decoration:
                    InputDecoration(labelText: 'Number of Event Participants'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Only digits allowed
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
