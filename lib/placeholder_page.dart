import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF7F0),
      appBar: AppBar(
          backgroundColor: const Color(0xFFFBF7F0),
          title: Text(
              'Coming Soon',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Urbanist',
              color: Color(0xFF301600),
              fontWeight: FontWeight.bold,
            ),
          )),
      body: Center(
        child: Text(
          'This page is under construction',
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Urbanist',
              color: Colors.black54,
              fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
