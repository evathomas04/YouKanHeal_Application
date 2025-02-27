import 'package:flutter/material.dart';

class RemoveUsersPage extends StatelessWidget {
  const RemoveUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remove Users'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Implement user removal logic
          },
          child: const Text('Remove User'),
        ),
      ),
    );
  }
}
