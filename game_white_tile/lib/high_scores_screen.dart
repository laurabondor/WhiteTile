import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighScoresScreen extends StatefulWidget {
  @override
  _HighScoresScreenState createState() => _HighScoresScreenState();
}

class _HighScoresScreenState extends State<HighScoresScreen> {
  List<int> highScores = [];

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
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'High Scores',
                style: TextStyle(fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: highScores.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Score: ${highScores[index]}',
                      style: TextStyle(color: Colors.white),
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