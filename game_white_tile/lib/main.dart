import 'package:flutter/material.dart';
import 'menu_screen.dart';
import 'game_screen.dart';
import 'high_scores_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'White Tile Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/game': (context) => const GameScreen(),
        '/high_scores': (context) => const HighScoresScreen(),
      },
    );
  }
}