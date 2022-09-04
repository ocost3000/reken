import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Split-it")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(20),
              child: const Text("Welcome to Reken!")),
          Center(
              child: ElevatedButton(
                  onPressed: () =>
                      {Navigator.pushNamed(context, '/calculator')},
                  child: const Text("New Receipt")))
        ],
      ),
    );
  }
}
