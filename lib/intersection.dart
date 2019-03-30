enum Stone { vacant, black, white }
enum Mark { none, x, o }

class Intersection {
  Stone stone;
  Mark mark;
  bool libertyChecked;

  Intersection() {
    stone = Stone.vacant;
    mark = Mark.none;
    libertyChecked = false;
  }

  void inverteStone() {
    if (stone == Stone.black)
      stone = Stone.white;
    else if (stone == Stone.white) 
      stone = Stone.black;
  }
}
