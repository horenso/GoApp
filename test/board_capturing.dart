import 'package:flutter_go_app/board.dart';

void main() {
  print('Basic capturing:');
  print('----');

  Board b1 = new Board(4);

  b1.putStone(1, 2, true);
  b1.putStone(2, 3, true);
  b1.putStone(3, 2, true);
  b1.putStone(4, 1, true);
  b1.putStone(2, 2, false);
  b1.putStone(1, 1, false);
  b1.putStone(3, 1, false);

  print(b1.toString(coordinates: false));

  print('----');
  print('Black tries (2, 1): '+b1.move(2, 1).toString());

  print(b1.toString(coordinates: false));

  print('----');
  print('Capturing big groups:');
  print('----');

  Board b2 = new Board(4);
  b2.putStone(1, 1, false);
  b2.putStone(2, 1, false);
  b2.putStone(3, 1, false);
  b2.putStone(4, 1, false);
  b2.putStone(1, 2, false);
  b2.putStone(2, 2, false);
  b2.putStone(3, 2, false);
  b2.putStone(4, 2, false);
  b2.putStone(1, 3, false);
  b2.putStone(2, 3, false);
  b2.putStone(3, 3, false);
  b2.putStone(4, 3, false);
  b2.putStone(1, 4, false);
  b2.putStone(2, 4, false);
  b2.putStone(3, 4, false);

  print(b2.toString(coordinates: false));
  print('----');
  print('Black tries (4, 4): '+b2.move(4, 4).toString());

  print(b2.toString(coordinates: false));

  print('----');
  print('Two eyes and suicide:');
  print('----');

  Board b3 = new Board(4);
  b3.putStone(1, 1, false);
  b3.putStone(2, 1, false);
  b3.putStone(3, 1, false);
  b3.putStone(4, 1, false);
  b3.putStone(1, 2, false);
  b3.putStone(2, 2, false);
  b3.putStone(4, 2, false);
  b3.putStone(1, 3, false);
  b3.putStone(2, 3, false);
  b3.putStone(3, 3, false);
  b3.putStone(4, 3, false);
  b3.putStone(1, 4, false);
  b3.putStone(2, 4, false);
  b3.putStone(3, 4, false);

  print(b3.toString(coordinates: false));

  print('----');
  print('Black tries (4, 4): '+b3.move(4, 4).toString());

  print(b3.toString(coordinates: false));

  print('KO capturing:');
  print('----');

  Board b4 = new Board(4);

  b4.putStone(1, 2, true);
  b4.putStone(1, 3, true);
  b4.putStone(2, 3, true);
  b4.putStone(1, 1, false);
  b4.putStone(2, 2, false);
  b4.putStone(3, 1, false);

  print(b4.toString(coordinates: false));
  print('(Board hashcode: '+b4.hashCode.toString()+')');

  print('----');
  print('Black tries (2, 1): '+b4.move(2, 1).toString());
  print(b4.toString(coordinates: false));
  print('(Board hashcode: '+b4.hashCode.toString()+')');

  print('----');
  print('White tries (1, 1): '+b4.move(1, 1).toString());
  print(b4.toString(coordinates: false));
  print('(Board hashcode: '+b4.hashCode.toString()+')');

  print('Suicid rule:');
  print('----');

  Board b5 = new Board(4);

  b5.putStone(1, 2, true);
  b5.putStone(1, 3, true);
  b5.putStone(2, 3, true);
  b5.putStone(3, 2, true);
  b5.putStone(3, 3, true);
  b5.putStone(4, 1, true);
  b5.putStone(4, 2, true);

  b5.putStone(1, 1, false);
  b5.putStone(2, 2, false);
  b5.putStone(3, 1, false);

  b5.invertStones();

  print(b5.toString(coordinates: false));

  print('----');
  print('Black tries (2, 1): '+b5.move(2, 1).toString());

  print(b5.toString(coordinates: false));
  print('----');
}
