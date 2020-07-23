import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TicTacToe()
  ));
}

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {

  // 0 for blank, 1 for X, 2 for O
  List<int> board = [
    0, 0, 0,
    0, 0, 0,
    0, 0, 0
  ];
  int currentTurn = 1;
  int playerXScore = 0;
  int playerOScore = 0;
  int currentNumMarks = 0;
  String turnText = "Player X's turn";

  Widget markToImage(int mark) {
    if (mark == 0) {
      return SizedBox();
    } else if (mark == 1) {
      return Image.asset('assets/x.png');
    } else {
      return Image.asset('assets/o.png');
    }
  }

  void onMarkPress() {
    currentNumMarks++;

    if (currentTurn == 1) {
      currentTurn = 2;
      turnText = "Player O's turn";
    } else {
      currentTurn = 1;
      turnText = "Player X's turn";
    }

    // check rows for a win
    for (int i=0; i<3; i++) {
      if (board[i*3] == board[i*3 + 1] && board[i*3 + 1] == board[i*3 + 2] && board[i*3] != 0) {
        startNewRound(board[i*3]);
        return;
      }
    }

    // check columns for a win
    for (int i=0; i<3; i++) {
      if (board[i] == board[i + 3] && board[i + 3] == board[i + 6] && board[i] != 0) {
        startNewRound(board[i]);
        return;
      }
    }

    // check diagonals for a win
    if (board[0] == board[4] && board[4] == board[8] && board[0] != 0) {
      startNewRound(board[0]);
      return;
    }
    if (board[2] == board[4] && board[4] == board[6] && board[2] != 0) {
      startNewRound(board[2]);
      return;
    }

    // 9 marks and no winner, draw
    if(currentNumMarks == 9)
      startNewRound(0);
  }

  void startNewRound(int winner) {
    currentTurn = 0;
    if (winner == 1) {
      playerXScore++;
      turnText = 'Player X Scores!';
    } else if (winner == 2) {
      playerOScore++;
      turnText = 'Player O Scores!';
    } else {
      turnText = 'Draw!';
    }

    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        currentNumMarks = 0;
        currentTurn = 1;
        turnText = "Player X's turn";
        for (int i=0; i<9; i++) {
          board[i] = 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tic-Tac-Toe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown[800],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30.0),
        color: Colors.brown[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Player X',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$playerXScore',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Player O',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$playerOScore',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ]
            ),
            Stack(
              children: <Widget>[
                Image.asset('assets/grid.png'),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: board.asMap().entries.map((mark) {
                    return FlatButton(
                      onPressed: () {
                        int buttonIndex = mark.key;
                        if (board[buttonIndex] == 0 && currentTurn != 0) {
                          setState(() {
                            board[buttonIndex] = currentTurn;
                            onMarkPress();
                          });
                        }
                      },
                      child: markToImage(mark.value),
                    );
                  }).toList(),
                )
              ],
            ),
            Text(
              '$turnText',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              )
            )
          ],
        ),
      )
    );
  }
}
