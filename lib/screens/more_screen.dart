import 'package:flutter/material.dart';
import 'package:todo/theme/app_decorations.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
          flexibleSpace: Container(
          decoration: kAppBarDecoration,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image(
              image: Image.asset('/icons/char.png').image,
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
