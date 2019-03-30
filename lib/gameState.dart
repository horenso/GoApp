import 'package:flutter_go_app/board.dart';

enum RuleSet { japanese, chinese }

/// Discribes one current game state, the state when going through Nodes
class GameState {
  Board currentBoard;
  RuleSet rules; 
  double komi; // points white gets 
  bool reverseKomi; // black gets komi instead
  int handicapStones; // how many preset stones does black get due to handicap


  GameState(int boardSize)
}