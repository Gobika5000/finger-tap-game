import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(FingerTapGame());
}

class FingerTapGame extends StatefulWidget {
  @override
  _FingerTapGameState createState() => _FingerTapGameState();
}

class _FingerTapGameState extends State<FingerTapGame> {
  int _score = 0;
  int _timer = 10; // 10 seconds to tap
  bool _gameOver = false;
  late Timer _timerCountdown;

  // Start the timer countdown when game starts
  void _startGame() {
    _score = 0;
    _gameOver = false;
    _timer = 10;
    _timerCountdown = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timer > 0) {
          _timer--;
        } else {
          _gameOver = true;
          _timerCountdown.cancel();
        }
      });
    });
  }

  // Increment score on tap
  void _onTap() {
    if (!_gameOver) {
      setState(() {
        _score++;
      });
    }
  }

  // Display a dialog when the game is over
  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over!'),
          content: Text('Your score is: $_score'),
          actions: <Widget>[
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _startGame(); // Restart the game
              },
            ),
            TextButton(
              child: Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _gameOver = true;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _startGame(); // Start the game when the app launches
  }

  @override
  void dispose() {
    _timerCountdown.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Finger Tap Game'),
        ),
        body: GestureDetector(
          onTap: _onTap,
          child: Container(
            color: Colors.blue[100],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Tap anywhere!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Score: $_score',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Time Left: $_timer',
                    style: TextStyle(fontSize: 24),
                  ),
                  if (_gameOver) ...[
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _showGameOverDialog,
                      child: Text('Game Over! Tap to Play Again'),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
