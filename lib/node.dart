class Node {}

/// Root node of the game, contains basic information
class RootNode extends Node {
  // player details
  String playerBlack; // PB
  String playerWhite; // PW
  String blackRank; // BR
  String whiteRank; // WR
  String blackCountry; // BC
  String whiteCountry; // WC
  String blackTeam; // BT

  // event details
  String event; // EV
  String round; // RO
  String date; // DT TODO: Maybe deal with real dates, let's see
  String place; // PC

  // game details
  String time; // TM TODO: Again, should I deal with that as a number?
  String overTime; // OT
  String periodLength; // LC
  String numberOfPeriods; // LT TODO: everthing is String just for now!
  double komi; // KM, usually 5.5, 6.5 or 7.5 points for white
  int handicap; // HA
  int size; // SZ of the board, std is 19
  String ruleSet; 
  RootNode();
}

class MoveNode extends Node {
  
}
