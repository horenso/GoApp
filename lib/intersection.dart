enum Stone { vacant, black, white }

class Intersection {
  Stone stone;
  String mark; // sgf allows different marks like x, o, triangle, letters
  bool libertyChecked; // for liberty counting
  bool hoshi; // whether this intersection is a star-point (hoshi)

  Intersection() {
    stone = Stone.vacant;
    mark = '';
    libertyChecked = false;
    hoshi = false;
  }

  /// returns the text representation of that interesetion
  String get character {
    // just for debugging, libertyChecked should always be reset
    if (libertyChecked) return 'u';

    if (stone == Stone.vacant)
      return '+';
    else if (stone == Stone.black)
      return '#';
    else
      return 'O';
  }

  void inverteStone() {
    if (stone == Stone.black)
      stone = Stone.white;
    else if (stone == Stone.white) stone = Stone.black;
  }
}
