import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Tic-Tac-Toe",
        home: Scaffold(body: Center(child: Game(key: gameKey))));
  }
}

final gameKey = GlobalKey<_GameState>();

class Game extends StatefulWidget {
  String turn = "x";
  List tiles = List.generate(3, (_) => List.generate(3, (_) => ""));
  Game({GlobalKey? key, turn}) : super(key: key);
  @override
  _GameState createState() => _GameState();
  checkThree() {
    for (var i = 0; i < tiles.length; i++) {
      if (tiles[i][0] != "" &&
          (tiles[i][0] == tiles[i][1] && tiles[i][1] == tiles[i][2])) {
        return tiles[i][0];
      }
      if (tiles[0][i] != "" &&
          (tiles[0][i] == tiles[1][i] && tiles[1][i] == tiles[2][i])) {
        return tiles[0][i];
      }
    }
    if (tiles[1][1] != "" &&
        ((tiles[0][0] == tiles[1][1] && tiles[1][1] == tiles[2][2]) ||
            (tiles[0][2] == tiles[1][1] && tiles[1][1] == tiles[2][0]))) {
      return tiles[1][1];
    }
    if (tiles.every((e) => e.every((a) => a != ""))) {
      return "tie";
    }
    return false;
  }
}

class _GameState extends State<Game> {
  var tileElems;
  var turn;
  var winner;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(winner != "" ? winner : turn.toUpperCase() + "'s turn"),
        Table(
          border: TableBorder.all(),
          children: tileElems,
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          defaultColumnWidth: const IntrinsicColumnWidth(),
        ),
        TextButton(onPressed: () => initData(), child: const Text("New game"))
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    widget.turn = "x";
    widget.tiles = List.generate(3, (_) => List.generate(3, (_) => ""));
    setState(() {
      turn = "x";
      winner = "";
      tileElems = List.generate(3, (index) {
        return TableRow(
            children: List.generate(3, (index2) {
          return Tile(game: widget, coords: [index, index2]);
        }));
      });
    });
  }

  void update(newGame) {
    setState(() {
      turn = newGame.turn;
      if (newGame.checkThree() != false) {
        if (newGame.checkThree() == "tie") {
          winner = "It's a tie!";
        } else {
          winner = newGame.checkThree().toString().toUpperCase() + " wins!";
        }
      }
    });
  }
}

class Tile extends StatefulWidget {
  List coords;
  String owner = "";
  Game game;
  Tile({required this.game, required this.coords, Key? key, owner})
      : super(key: key);
  @override
  _PlayedState createState() => _PlayedState();
}

class _PlayedState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(widget.owner == "x"
            ? Icons.close
            : widget.owner == "o"
                ? Icons.circle_outlined
                : Icons.abc),
        onPressed: _takeTurn,
        iconSize: widget.owner == "" ? 0 : null,
        visualDensity: VisualDensity.comfortable,
        color: widget.owner == "x"
            ? Colors.red
            : widget.owner == "o"
                ? Colors.blue
                : Colors.white,
      ),
    );
  }

  void _takeTurn() {
    setState(() {
      if (widget.owner != "" || widget.game.checkThree() != false) {
        return;
      }
      widget.owner = widget.game.turn;
      widget.game.turn = widget.game.turn == "x" ? "o" : "x";
      widget.game.tiles[widget.coords[0]][widget.coords[1]] = widget.owner;
      gameKey.currentState?.update(widget.game);
    });
  }
}
