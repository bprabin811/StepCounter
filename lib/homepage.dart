import 'package:flutter/material.dart';
import 'package:tracker/utl/foot_step.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),
            const MyFootStep(),
            const SizedBox(
              height: 25,
            ),
            Divider(
              height: 2,
              color: Colors.red.shade800,
              indent: 10,
              endIndent: 10,
            ),
           
            Container(
              height: 50,
              child: const Center(child: Text('P r o W i n',)))
          ],
        ),
      ),
    );
  }
}