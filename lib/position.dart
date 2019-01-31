/// Each position has a color, represented by a bool colorIsBlack (false=white, true=black)
/// an optional as well as a ko mark 
class Position {
  bool colorIsBlack;
  int symbol;
  bool ko;

  void swapColor() {
    colorIsBlack = !colorIsBlack;
  }
}