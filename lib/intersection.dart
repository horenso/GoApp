enum Stone { vacant, black, white }
enum Mark {
  none,
  x,
  tri,
  o,
  letterA,
  letterB,
  letterC,
  letterD,
  letterE,
  letterF,
  letterG,
  letterH,
  letterI,
  letterJ,
  letterK,
  letterL,
  letterM,
  letterN,
  letterO,
  letterP,
  letterQ,
  letterR,
  letterS,
  letterT,
  letterU,
  letterV,
  letterW,
  letterX,
  letterY,
  letterZ
}

class Intersection {
  Stone stone;
  Mark mark; // sgf allows different marks like x, o, triangle ...
  bool libertyChecked; // for liberty counting
  bool hoshi; // whether this intersection is a star-point (hoshi)

  Intersection() {
    stone = Stone.vacant;
    mark = Mark.none;
    libertyChecked = false;
    hoshi = false;
  }

  void inverteStone() {
    if (stone == Stone.black)
      stone = Stone.white;
    else if (stone == Stone.white) stone = Stone.black;
  }
}
