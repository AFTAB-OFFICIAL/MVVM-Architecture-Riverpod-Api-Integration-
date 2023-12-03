import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Error Page',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Text(error),
        ),
      ),
    );
  }
}
