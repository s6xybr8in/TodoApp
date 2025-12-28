import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
          flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4F46E5), // indigo
                Color(0xFF7C3AED), // violet
                Color(0xFF2563EB), // blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image(
              image: AssetImage('../../assets/icons/char.png'),
              width: 300,
              height: 300,
            ),
            SizedBox(height: 16),
            Text('More information will be here.'),
          ],
        ),
      ),
    );
  }
}
