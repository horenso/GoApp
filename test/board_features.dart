import 'package:flutter_go_app/board.dart';

void main() {
  print('Basic Rotation/Mirroring:');
  print('----');

  Board b1 = new Board(5);

  b1.putStone(1, 2, true);
  b1.putStone(3, 3, true);
  b1.putStone(2, 3, false);

  print(b1.toString(coordinates: false));
  print('----');

  print('Rotate clockwise:');
  b1.rotatePosition(clockwise: true);

  print(b1.toString(coordinates: false));
  print('----');

  print('Switch colors:');
  b1.invertStones();

  print(b1.toString(coordinates: false));
  print('----');

  print('Mirror along x:');
  b1.invertPosition(alongX: true);

  print(b1.toString(coordinates: false));
  print('----');

  print('Mirror along y:');
  b1.invertPosition(alongX: false);

  print(b1.toString(coordinates: false));
  print('----');

  print('Rotate anticlockwise:');
  b1.rotatePosition(clockwise: false);

  print(b1.toString(coordinates: false));
  print('----');
}
