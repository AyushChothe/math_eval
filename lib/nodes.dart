abstract class Node {
  @override
  String toString() {
    return "$runtimeType";
  }

  Node copy();
}

class NumberNode implements Node {
  double value;
  NumberNode(this.value);

  @override
  String toString() {
    return "$value";
  }

  @override
  Node copy() {
    return NumberNode(value);
  }
}

class PlusNode implements Node {
  Node node;

  PlusNode(this.node);

  @override
  String toString() {
    return "(+$node)";
  }

  @override
  Node copy() {
    return PlusNode(node);
  }
}

class MinusNode implements Node {
  Node node;

  MinusNode(this.node);

  @override
  String toString() {
    return "(-$node)";
  }

  @override
  Node copy() {
    return MinusNode(node);
  }
}

class BinOpNode implements Node {
  Node a;
  Node b;
  String op;

  BinOpNode(this.a, this.op, this.b);

  @override
  String toString() {
    return "($a$op$b)";
  }

  @override
  Node copy() {
    return BinOpNode(a, op, b);
  }
}
