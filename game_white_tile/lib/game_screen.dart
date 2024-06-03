import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'tile_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int gridSize = 4;
  static const int initialSpeed = 750;
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<List<bool>> grid = List.generate(gridSize, (_) => List.generate(gridSize, (_) => false));
  int score = 0;
  int speed = initialSpeed;
  bool gameOver = false;
  bool restartRequested = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    setState(() {
      score = 0;
      speed = initialSpeed;
      gameOver = false;
      restartRequested = false;
      grid = List.generate(gridSize, (_) => List.generate(gridSize, (_) => false));
    });
    gameLoop();
  }

  void gameLoop() async {
    while (!gameOver && !restartRequested) {
      await Future.delayed(Duration(milliseconds: speed));
      if (!gameOver && !restartRequested) {
        moveTilesDown();
        checkForGameOver();
        increaseSpeed();
      }
    }
    if (!restartRequested) {
      saveHighScore();
      showGameOverDialog();
    }
  }

  void moveTilesDown() {
    setState(() {
      for (int i = gridSize - 1; i > 0; i--) {
        grid[i] = List.from(grid[i - 1]);
      }
      int randomCol = Random().nextInt(gridSize);
      grid[0] = List.generate(gridSize, (index) => index == randomCol);
    });
  }

  void checkForGameOver() {
    for (int col = 0; col < gridSize; col++) {
      if (grid[gridSize - 1][col]) {
        setState(() {
          gameOver = true;
        });
        return;
      }
    }
  }

  void increaseSpeed() {
    if (speed > 100) {
      speed -= 10;
    }
  }

  void handleTileTap(int row, int col) {
    if (grid[row][col]) {
      _audioPlayer.play(AssetSource('assets/sound.mp3'));
      setState(() {
        score++;
        grid[row][col] = false;
      });
    } else {
      setState(() {
        gameOver = true;
      });
      saveHighScore();
      showGameOverDialog();
    }
  }

  Future<void> saveHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> highScores = (prefs.getStringList('highScores') ?? []);
    highScores.add(score.toString());
    highScores.sort((a, b) => int.parse(b).compareTo(int.parse(a)));
    if (highScores.length > 10) {
      highScores = highScores.sublist(0, 10);
    }
    prefs.setStringList('highScores', highScores);
  }

  Future<void> shareScore() async {
    final String text = 'I scored $score points in White Tile Game!';
    Share.share(text, subject: 'My Game Score');
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your score: $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
              child: const Text('Restart'),
            ),
            TextButton(
              onPressed: shareScore,
              child: const Text('Share Score'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: const Text('Back to Menu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Score: $score'),
      ),
      body: Column(
        children: [
          for (int row = 0; row < gridSize; row++)
            Expanded(
              child: Row(
                children: [
                  for (int col = 0; col < gridSize; col++)
                    Expanded(
                      child: TileWidget(
                        isBlack: grid[row][col],
                        onTap: () => handleTileTap(row, col),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}