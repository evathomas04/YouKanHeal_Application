import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class GreenProtocolDataPage extends StatefulWidget {
  const GreenProtocolDataPage({Key? key}) : super(key: key);

  @override
  _GreenProtocolDataPageState createState() => _GreenProtocolDataPageState();
}

class _GreenProtocolDataPageState extends State<GreenProtocolDataPage> {
  final DatabaseReference _databaseRef =
  FirebaseDatabase.instance.ref('green_protocol_form');
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

  // Request storage permission for Android 10+ and 11+
  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      // For Android 11+, request MANAGE_EXTERNAL_STORAGE permission
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      // For Android 10 and below, request storage permission
      final status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      } else if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Storage permission is required to save the file.'),
          ),
        );
        return false;
      } else if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Storage permission is permanently denied. Enable it from app settings.',
            ),
            action: SnackBarAction(
              label: 'Open Settings',
              onPressed: () async {
                await openAppSettings();
              },
            ),
          ),
        );
        return false;
      }
    }
    return true; // For iOS, permission handling is different
  }
  /*
  // Convert data to CSV format and download
  Future<void> _downloadCSV() async {
    if (!await _requestPermission()) return;

    List<List<String>> csvData = [];

    // Adding headers
    if (_data.isNotEmpty) {
      final columns = _data.first.keys.where((key) => key != 'id').toList();
      csvData.add(columns);

      // Adding data rows
      for (var row in _data) {
        final rowData = columns.map((column) {
          return row[column]?.toString() ?? 'N/A';
        }).toList();
        csvData.add(rowData);
      }

      // Convert to CSV
      String csv = const ListToCsvConverter().convert(csvData);

      // Get the path for saving the CSV file
      try {
        // For Android 10 and lower, use getExternalStorageDirectory
        final directory = await getExternalStorageDirectory();
        final path = '${directory?.path}/green_protocol_data.csv';
        final file = File(path);
        await file.writeAsString(csv);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CSV file downloaded to: $path'),
          ),
        );
      } catch (e) {
        print('Error saving CSV: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving file. Please try again.'),
          ),
        );
      }
    }
  }*/

  Widget _buildDataTable() {
    if (_data.isEmpty) {
      return const Center(child: Text('No data available.'));
    }

    final columns = _data.first.keys.where((key) => key != 'id').toList();
    if (columns.isNotEmpty) {
      final firstColumn = columns.removeAt(0);
      columns.add(firstColumn); // Move the first column to the last
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
        title: const Text('Green Protocol Data'),
        /*actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadCSV, // Call download CSV method
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
