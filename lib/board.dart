/// The board class keeps track of the current state of the game trees

import 'dart:io';

// checked referring to marks when counting liberties
enum Spot { vacant, black, white, black_checked, white_checked }

class Board {
  int size;
  List<List<Spot>> grid;
  bool blacksTurn;

  /// size can be between 2 and 25 
  Board(int size) {
    if (size >= 2 && size <= 25)
      this.size = size;
    else
      this.size = 19;

    this.grid = List<List<Spot>>.generate(
      size, (i) => List<Spot>.generate(size, (j) => Spot.vacant));

    this.blacksTurn = true;
  }

  /// returns ture if the given coodinates (col, row) are on the board
  bool coordsOnBoard(int col, int row) => (col >= 0 && col < size && row >= 0 && row < size);

  /// swaps turns between black and white
  void swapTurns() => blacksTurn = !blacksTurn;

  /// returns board as a String for testing
  String toString({bool coordinates = true}) {
    String s = '';

    // Adds ABC at the top
    if (coordinates) {
      for (int i = 0; i < size; i++) {
        s += String.fromCharCode(65+i) + ' ';
      }
      s += '\n';
    }

    int rowNum = 0;
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (grid[j][i] == Spot.vacant) {
          s += '+ ';
        } else if (grid[j][i] == Spot.black) {
          s += 'O ';
        } else if (grid[j][i] == Spot.black_checked) {
          s += 'o ';
        } else if (grid[j][i] == Spot.white_checked) {
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
  /// of stones has liberties, TODO: maybe this should be bool,
  /// anyways, it works but it doesn't take shared libterties into consideration 
  int countLiberties(bool countForBlack, int col, int row) {
    int liberties = 0;

    if (!coordsOnBoard(col, row))
      return 0;

    // checked already, no additional liberties here
    if (grid[col][row] == Spot.black_checked || grid[col][row] == Spot.white_checked)
      return 0;

    if (grid[col][row] == Spot.vacant)
      return 1;   

    // if Spot has the oponent's color, there is no liberty here
    if (countForBlack && grid[col][row] == Spot.white)
        return 0;
    if (!countForBlack && grid[col][row] == Spot.black)
        return 0;

    // print('Marked a stone in the countLibterties function.');
    // mark as checked
    if (grid[col][row] == Spot.white)
      grid[col][row] = Spot.white_checked;
    if (grid[col][row] == Spot.black)
      grid[col][row] = Spot.black_checked;

    // Checking adjacent spots, here is where the recursion happens
    liberties += (countLiberties(countForBlack, col-1, row));
    liberties += (countLiberties(countForBlack, col+1, row));
    liberties += (countLiberties(countForBlack, col, row-1));
    liberties += (countLiberties(countForBlack, col, row+1));

    return liberties;
  }

  /// This methode changes marked_black to black and marked_white to white,
  /// if remove is true, those stones will be replaced by vacant instead
  void clearMarks({bool remove = false}) {
    // print('Clearing Marks! Remove: ' + remove.toString());
    for (int col = 0; col < size; col++) {
      for (int row = 0; row < size; row++) {
        if (remove) { // if remove option, both black_checked and white_checked => vacant
          if (grid[col][row] == Spot.black_checked || grid[col][row] == Spot.black_checked) {
            grid[col][row] = Spot.vacant;
            // print('vacant');
          }
        } else { // Not remove option, colors become their original 
         if (grid[col][row] == Spot.black_checked) {
            // print('replaced');
            grid[col][row] = Spot.black;
          } else if (grid[col][row] == Spot.white_checked) {
            grid[col][row] = Spot.white;
            // print('replaced');
          }
        }
      }
    }
  }

  /// Swaps colors on the board around, TODO: keep symbols when inverting
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
    Spot temp;

    if (alongX) {
      for (int col = 0; col < (size/2).ceil(); col++) {
        for (int row = 0; row < size; row++) {
          temp = grid[col][row];
          grid[col][row] = grid[size-col-1][row];
          grid[size-col-1][row] = temp;
        }
      }
    } else {
      for (int col = 0; col < size; col++) {
        for (int row = 0; row < (size/2).ceil(); row++) {
          temp = grid[col][row];
          grid[col][row] = grid[col][size-row-1];
          grid[col][size-row-1] = temp;
        }
      }  
    }
  }

  /// normal matrix transposition, swapping indices 
  void transposePosition() {
    Spot temp;

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
    if ( coordsOnBoard(col+1, row) )
      clearMarks(remove: countLiberties(!blacksTurn, col+1, row) == 0);
    
    if ( coordsOnBoard(col-1, row) )
      clearMarks(remove: countLiberties(!blacksTurn, col-1, row) == 0);
        
    if ( coordsOnBoard(col, row+1) )
      clearMarks(remove: countLiberties(!blacksTurn, col, row+1) == 0);
          
    if ( coordsOnBoard(col, row-1) )
      clearMarks(remove: countLiberties(!blacksTurn, col, row-1) == 0);
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
  /// putting the stone, checking for groups with no liberties, removing them
  /// and swapping turns 
  void move(int col, int row) {
    if (!putStone(col, row, blacksTurn))
      return;

    removeCaptures(col, row);
    clearMarks(remove: false);
    swapTurns();
  }
}

void main() {
  Board b = new Board(19);

  b.putStone(2, 0, false);

  print(b.toString(coordinates: true));

  

  while (true) {
    stdout.write("col: ");
    int col = int.parse(stdin.readLineSync());

    stdout.write("row: ");
    int row = int.parse(stdin.readLineSync());

    b.move(col, row);
    // print('This group has '+b.countLiberties(!b.blacksTurn, col, row).toString()+' liberties.');


    // print('Next move is blacks turn:'+b.blacksTurn.toString());

    print(b.toString(coordinates: true));
  }
}