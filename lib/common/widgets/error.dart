import 'package:flutter/material.dart';

class ErrorHandel extends StatelessWidget {
  final String error;

  const ErrorHandel({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text(error),
            ),
          ],
        ),
      ),
    );
  }
}
