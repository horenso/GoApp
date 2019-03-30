import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Awesome Go App",
      home: Scaffold(
        appBar: new AppBar(
          title: Text("Awesome Go App!"),
          backgroundStone: Stones.blue,
        ),
        body: Center(child: new Text("This is almost real time!")),
      ),
    );
  }
}