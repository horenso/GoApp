class Node {
  int id; // unique node id
  int parentId; 
  List<Node> children;

  Node(parentId) {
    this.parentId = parentId;
    this.children = null;
  }
}

class MoveNode extends Node {
  MoveNode(parentId) : super(parentId);
}

class CommentNode extends Node {
  CommentNode(parentId) : super(parentId);
}