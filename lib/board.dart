/// The board class keeps track of the current state of the game trees

import 'intersection.dart';

import 'dart:io';

/// Represents the current state of the board, the size,
/// which stones are on the board and whoes turn it is.
/// Additionaly every board can return a unique hash to
/// to handle ko.
class Board {
  int size;
  List<List<Intersection>> grid;
  bool blacksTurn;

  /// size can be between 2 and 25
  Board(int size) {
    if (size >= 2 && size <= 25)
      this.size = size;
    else
      this.size = 19;

    this.grid = List<List<Intersection>>.generate(
        size, (i) => List<Intersection>.generate(size, (j) => Intersection()));

    this.blacksTurn = true;
  }

  /// hashCode of the board TODO: maybe find a quicker way 
  @override
  int get hashCode => toString(coordinates: false).hashCode; 

  /// equals operator returns equal if two Boards have the same hashCode
  @override
  bool operator ==(other) => other is Board && other.hashCode == hashCode;

  /// returns ture if the given coodinates (col, row) are on the board
  bool coordsOnBoard(int col, int row) =>
      (col >= 0 && col < size && row >= 0 && row < size);

  /// swaps turns between black and white
  void swapTurns() => blacksTurn = !blacksTurn;

  /// returns board as a String for testing
  String toString({bool coordinates = true}) {
    String s = '';

    // Adds ABC at the top
    if (coordinates) {
      for (int i = 0; i < size; i++) {
        s += String.fromCharCode(65 + i) + ' ';
      }
      s += '\n';
    }

    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        s += grid[col][row].character;
        if (col + 1 < size) s += ' ';
      }
      if (coordinates) {
        s += (row + 1).toString();
      }
      if (row + 1 < size) s += '\n';
    }

    return s;
  }

  /// Recursive floodfill algorithm that checks whether a group
  /// of stones has liberties, TODO: maybe this should be bool,
  /// anyways, it works but it doesn't take shared libterties into consideration
  bool hasLiberties(bool countForBlack, int col, int row) {
    if (!coordsOnBoard(col, row)) return false;

    // checked already, no additional liberties here
    if (grid[col][row].libertyChecked) return false;

    // empty intersection has a liberty
    if (grid[col][row].stone == Stone.vacant) return true;

    // if Intersection has the oponent's stone, there is no liberty here
    if (countForBlack && grid[col][row].stone == Stone.white) return false;
    if (!countForBlack && grid[col][row].stone == Stone.black) return false;

    // print('Marked a stone in the countLibterties function.');
    // mark as checked
    grid[col][row].libertyChecked = true;

    // Checking adjacent Intersections, here is where the recursion happens
    return (hasLiberties(countForBlack, col - 1, row) ||
        hasLiberties(countForBlack, col + 1, row) ||
        hasLiberties(countForBlack, col, row - 1) ||
        hasLiberties(countForBlack, col, row + 1));
  }

  /// This methode removes the hasLiberties mark from every stone,
  /// if remove is active, stones will be removed
  void clearMarks({bool remove = false}) {
    for (int col = 0; col < size; col++) {
      for (int row = 0; row < size; row++) {
        if (grid[col][row].libertyChecked) {
          grid[col][row].libertyChecked = false;
          if (remove) grid[col][row].stone = Stone.vacant;
        }
      }
    }
  }

  /// Swaps stones on the board around
  void invertStones() {
    for (List<Intersection> row in grid) {
      for (Intersection current_spot in row) {
        current_spot.inverteStone();
      }
    }
  }

  /// Invertes the position,
  void invertPosition({bool alongX = true}) {
    Intersection temp;

    if (alongX) {
      for (int col = 0; col < (size / 2).ceil(); col++) {
        for (int row = 0; row < size; row++) {
          temp = grid[col][row];
          grid[col][row] = grid[size - col - 1][row];
          grid[size - col - 1][row] = temp;
        }
      }
    } else {
      for (int col = 0; col < size; col++) {
        for (int row = 0; row < (size / 2).ceil(); row++) {
          temp = grid[col][row];
          grid[col][row] = grid[col][size - row - 1];
          grid[col][size - row - 1] = temp;
        }
      }
    }
  }

  /// normal matrix transposition, swapping indices
  void transposePosition() {
    Intersection temp;

    for (int col = 0; col < size; col++) {
      for (int row = 0; row < col; row++) {
        temp = grid[col][row];
        grid[col][row] = grid[row][col];
        grid[row][col] = temp;
      }
    }
  }

  /// Rotates the board by 90 degrees
  void rotatePosition({bool clockwise = true}) {
    transposePosition();
    invertPosition(alongX: !clockwise);
  }

  /// Removes groups of stones with no liberties
  /// on the four adjecent places arount (col, row)
  void removeCaptures(int col, int row) {
    if (coordsOnBoard(col + 1, row))
      clearMarks(remove: !hasLiberties(!blacksTurn, col + 1, row));

    if (coordsOnBoard(col - 1, row))
      clearMarks(remove: !hasLiberties(!blacksTurn, col - 1, row));

    if (coordsOnBoard(col, row + 1))
      clearMarks(remove: !hasLiberties(!blacksTurn, col, row + 1));

    if (coordsOnBoard(col, row - 1))
      clearMarks(remove: !hasLiberties(!blacksTurn, col, row - 1));
  }

  /// puts a stone on one Intersection, the difference between putStone and move is
  /// that capures are not taken into account and the turn is not swaped
  /// return true if put correctly
  bool putStone(int col, int row, bool putBlack) {
    // convert to normal coordinates, starting at (1,1)
    col--;
    row--;

    if (!coordsOnBoard(col, row)) return false; // Not within the board
    if (grid[col][row].stone != Stone.vacant) return false; // Already occupied

    if (putBlack)
      grid[col][row].stone = Stone.black;
    else
      grid[col][row].stone = Stone.white;
    return true; // put stone successfully
  }

  /// player move consists of:
  /// putting the stone, checking for groups with no liberties, removing them
  /// and swapping turns
  bool move(int col, int row) {
    // first but the stone on the board
    if (!putStone(col, row, blacksTurn))
      return false; // return if putstone() not possible

    removeCaptures(col - 1, row - 1);

    if (!hasLiberties(blacksTurn, col - 1, row - 1)) {
      grid[col - 1][row - 1].stone = Stone.vacant;
      clearMarks();
      return false;
    }
    clearMarks();

    swapTurns();
    return true;
  }
}

main(List<String> args) {
  Board b = new Board(19);

  b.putStone(2, 0, false);

  print(b.toString(coordinates: false));

  Board b1 = new Board(19);

  b1.putStone(4, 4, true);
  b1.putStone(3, 3, true);
  b1.putStone(4, 2, true);
  b1.putStone(4, 10, false);

  while (true) {
    stdout.write("col: ");
    int col = int.parse(stdin.readLineSync());

    stdout.write("row: ");
    int row = int.parse(stdin.readLineSync());

    b.move(col, row);
    // print('This group has '+b.hasLiberties(!b.blacksTurn, col, row).toString()+' liberties.');

    // print('Next move is blacks turn:'+b.blacksTurn.toString());

    print(b.toString(coordinates: false));
  }
}
