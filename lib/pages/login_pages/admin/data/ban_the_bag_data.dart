import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io'; // For File operations
import 'package:path_provider/path_provider.dart'; // For directory paths
import 'package:csv/csv.dart'; // For CSV generation

class BanTheBagDataPage extends StatefulWidget {
  const BanTheBagDataPage({Key? key}) : super(key: key);

  @override
  _BanTheBagDataPageState createState() => _BanTheBagDataPageState();
}

class _BanTheBagDataPageState extends State<BanTheBagDataPage> {
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref('ban_the_bag_form');
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final snapshot = await _databaseRef.get();
      if (snapshot.value != null && snapshot.value is Map) {
        setState(() {
          _data = (snapshot.value as Map).entries.map((entry) {
            return {'id': entry.key, ...Map<String, dynamic>.from(entry.value)};
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _data = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

/*  Future<void> _downloadCSV() async {
    if (_data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data available to download.')),
      );
      return;
    }

    // Convert data to CSV format
    List<List<String>> csvData = [];

    // Add header row
    final columns = _data.first.keys.where((key) => key != 'id').toList();
    csvData.add(columns);

    // Add data rows
    for (var row in _data) {
      csvData.add(
          columns.map((column) => row[column]?.toString() ?? 'N/A').toList());
    }

    // Generate CSV string
    String csvString = const ListToCsvConverter().convert(csvData);

    // Save to a file
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/ban_the_bag_data.csv';
      final file = File(filePath);

      await file.writeAsString(csvString);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CSV file downloaded successfully!')),
      );

      print('CSV saved at: $filePath'); // Print file path for debugging
    } catch (e) {
      print('Error saving CSV: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving CSV file.')),
      );
    }
  }*/

  Widget _buildDataTable() {
    if (_data.isEmpty) {
      return const Center(child: Text('No data available.'));
    }

    final columns = _data.first.keys.where((key) => key != 'id').toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns:
              columns.map((column) => DataColumn(label: Text(column))).toList(),
          rows: _data.map((row) {
            return DataRow(
              cells: columns.map((column) {
                return DataCell(Text(row[column]?.toString() ?? 'N/A'));
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ban the Bag Data'),
        /*actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download CSV',
            onPressed: _downloadCSV,
          ),
        ],*/
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: _buildDataTable(),
            ),
    );
  }
}
