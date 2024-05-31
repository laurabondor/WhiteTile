import 'package:flutter/material.dart';
import 'menu_screen.dart';
import 'game_screen.dart';
import 'high_scores_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'White Tile Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MenuScreen(),
        '/game': (context) => GameScreen(),
        '/high_scores': (context) => HighScoresScreen(),
      },
    );
  }
}
