/// The board class keeps track of the current state of the game trees
///
/// TODO: Should turn be saved here?

import 'dart:io';

enum Spot { vacant, black, white, black_checked, white_checked }

int a = 0; // TODO: delete it

class Board {
  int size;
  List<List<Spot>> grid;
  bool blacksTurn;

  Board(int size) {
    if (size >= 2 && size <= 25)
      this.size = size;
    else
      this.size = 19;

    this.grid = List<List<Spot>>.generate(
      size, (i) => List<Spot>.generate(size, (j) => Spot.vacant));

    this.blacksTurn = true;
  }

  /// Checks whether the given coodinates are on the board
  bool coordsOnBoard(int col, int row) => (col >= 0 && col < size && row >= 0 && row < size);

  /// swaps turns between black and white
  void swapTurns() => blacksTurn = !blacksTurn;

  /// returns board as a String for testing
  String toString({bool coordinates = true}) {
    String s = '';

    // Adds ABC at the top
    if (coordinates) {
      for (int i = 0; i < size; i++) {
        s += i.toString() + ' ';
      }
      s += '\n';
    }

    int rowNum = 0;
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (grid[i][j] == Spot.vacant) {
          s += '+ ';
        } else if (grid[i][j] == Spot.black) {
          s += 'O ';
        } else if (grid[i][j] == Spot.black_checked) {
          s += 'o ';
        } else if (grid[i][j] == Spot.white_checked) {
          s += 'x ';
        } else {
          s += 'X ';
        }
      }
      if (coordinates) {
        s += rowNum.toString();
         // number + newlien
        rowNum++;
      }
      s += '\n';
    }

		return s;
  }

  /// Recursive floodfill algorithm that checks whether a group 
  /// of stones has liberties 
  int countLiberties(bool countForBlack, int col, int row) {
    // print('Count libterties for black:' + countForBlack.toString());
    // print('('+row.toString()+', '+col.toString()+')');

    int liberties = 0;

    if (!coordsOnBoard(col, row)) {
      print('Hit the edge while counting, ouch!');
      return 0;
    }

    // checked already, no luck here
    if (grid[col][row] == Spot.black_checked || grid[col][row] == Spot.white_checked) {
      print('Already checked');
      return 0;
    }

    if (grid[col][row] == Spot.vacant) {
      return 1;   
    }

    // if Spot has the oponent's color, there is no liberty here
    if (countForBlack) { 
      if (grid[col][row] == Spot.white) { 
        print('White stone occupies libertie of black');
        return 0;
      }
    } else {
      if (grid[col][row] == Spot.black) {
        print('Black stone occupies libertie of white');
        return 0;
      }
    }


    print('Marking spot as checked');
    // mark as checked
    if (grid[col][row] == Spot.white)
      grid[col][row] = Spot.white_checked;
    else if (grid[col][row] == Spot.black)
      grid[col][row] = Spot.black_checked;

    // Check accent spots
    int left = (countLiberties(countForBlack, col-1, row));
    int right = (countLiberties(countForBlack, col+1, row));
    int top = (countLiberties(countForBlack, col, row-1));
    int bottom = (countLiberties(countForBlack, col, row+1));

    print('LEFT: '+left.toString());
    print('RIGHT: '+right.toString());
    print('TOP: '+top.toString());
    print('BOTTOM: '+bottom.toString());  

    liberties += left+right+top+bottom;

    return liberties;
  }

  /// This methode changes marked_black to black and marked_white to white,
  /// if remove is true, those stones will be removed,
  void clearMarks({bool remove = false}) {
    print('Clearing Marks! Remove: ' + remove.toString());
    for (int col = 0; col < size; col++) {
      for (int row = 0; row < size; row++) {
        if (remove) { // if remove option, every check becomes a vacant spot
          if (grid[col][row] == Spot.black_checked || grid[col][row] == Spot.black_checked) {
            grid[col][row] = Spot.vacant;
            print('vacant');
          }
        } else { // Not remove option, colors become their original 
         if (grid[col][row] == Spot.black_checked) {
            print('replaced');
            grid[col][row] = Spot.black;
          } else if (grid[col][row] == Spot.white_checked) {
            grid[col][row] = Spot.white;
            print('replaced');
          }
        }
      }
    }
  }

  // swaps colors on the board around, TODO: keep symbols when inverting
  void invertColors() {
    for (int col = 0; col < size; col++) {
      for (int row = 0; row < size; row++) {
        if (grid[col][row] == Spot.white)
          grid[col][row] = Spot.black;
        else if (grid[col][row] == Spot.black)
          grid[col][row] = Spot.white;
      }
    }
  }

  /// Invertes the position,
  void invertPosition({bool alongX = true}) {
    List<List<Spot>> tempGrid = List<List<Spot>>.generate(size, 
      (i) => List<Spot>.generate(size, (j) => Spot.vacant));

    for (int col = 0; col < size; col++) {
      for (int row = 0; row < size; row++) {
        if (alongX)
          tempGrid[col][row] = grid[size-col-1][row];
        else
          tempGrid[col][row] = grid[col][size-row-1];
      }
    }
    grid = tempGrid;
  }

  void rotatePosition({bool clockwise = true}) {
    return; // TODO: implement
  }

  /// Removes groups of stones with no liberties
  /// 
  void removeCaptures(int col, int row) {
    if (coordsOnBoard(col-1, row))
      clearMarks(remove: true);
    
    if (coordsOnBoard(col+1, row))
      clearMarks(remove: true);

    if (coordsOnBoard(col, row-1))
      clearMarks(remove: true);

    if (coordsOnBoard(col, row+1))
      clearMarks(remove: true);
  }

  /// puts a stone on one spot, the difference between putStone and move is
  /// that capures are not taken into account and the turn is not swaped
  /// returns true if put correctly, otherwise false
  bool putStone(int col, int row, bool putBlack) {
    if (!coordsOnBoard(col, row)){
      return false; // Not within the board
    }

    if (grid[col][row] != Spot.vacant) {
      return false; // Already occupied
    }

    if (putBlack)
      grid[col][row] = Spot.black;
    else
      grid[col][row] = Spot.white;

    return true; // put stone successfully 
  }

  /// player move consists of:
  /// putting the stone, checking for groups with no liberties and removing them
  /// swapping turns 
  void move(int col, int row) {
    if (!putStone(col, row, blacksTurn))
      return;

    removeCaptures(col, row);
    clearMarks();
    swapTurns();
  }
}

void main() {
  Board b = new Board(19);

  b.putStone(10, 10, false);
  b.putStone(10, 9, true);
  b.putStone(9, 10, true);
  b.putStone(11, 10, true);

  print(b.toString(coordinates: true));

  while (true) {
    stdout.write("col: ");
    int col = int.parse(stdin.readLineSync());

    stdout.write("row: ");
    int row = int.parse(stdin.readLineSync());

    b.move(row, col);
    print('This group has '+b.countLiberties(b.blacksTurn, col, row).toString()+' liberties.');


    print('Next move is blacks turn:'+b.blacksTurn.toString());

    print(b.toString(coordinates: true));
  }
}