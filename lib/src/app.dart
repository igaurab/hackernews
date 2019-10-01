import 'package:flutter/material.dart';
import 'screens/newslist.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackerNews',
      home: NewsList(),
    );
  }
}