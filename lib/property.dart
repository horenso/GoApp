/// Each note consists of different properties that are
/// appended to that node
/// This will be the base call for properties
/// https://www.red-bean.com/sgf/user_guide/index.html#move_vs_place
class Property {
  // ...
}

/// A move property can either be a move or a move annotation like time...
/// there can only be one Move per Node!
class MoveProperty extends Property {
  bool blackMoved;
  int xCoordinate;
  int yCorrdinate; // ...
}

/// 
class SetupProperty extends Property {
  // ...
}