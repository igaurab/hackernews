import 'package:flutter/material.dart';
import 'screens/newslist.dart';
import './blocs/stories_provider.dart';
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoriesProvider(
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HackerNews',
      home: NewsList(),
    )
    );     
  }
}