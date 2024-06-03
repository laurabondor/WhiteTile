import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighScoresScreen extends StatefulWidget {
  const HighScoresScreen({super.key});

  @override
  _HighScoresScreenState createState() => _HighScoresScreenState();
}

class _HighScoresScreenState extends State<HighScoresScreen> {
  Set<int> highScores = {};

  @override
  void initState() {
    super.initState();
    loadHighScores();
  }

  Future<void> loadHighScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highScores = (prefs.getStringList('highScores') ?? [])
          .map((e) => int.parse(e))
          .toSet();
    });
  }

  Future<void> clearHighScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('highScores');
    setState(() {
      highScores.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<int> sortedScores = highScores.toList()..sort((a, b) => b.compareTo(a));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: clearHighScores,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'High Scores',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sortedScores.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Score: ${sortedScores[index]}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
