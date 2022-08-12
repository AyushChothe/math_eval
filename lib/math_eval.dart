import 'dart:math';

import 'package:math_eval/values.dart';

import 'nodes.dart';
import 'tokens.dart';

class Lexer {
  final Iterator _text;
  String? _currentChar;

  Lexer({
    required String text,
  }) : _text = text.split("").iterator {
    _advance();
  }

  void _advance() {
    _currentChar = _text.moveNext() ? _text.current : null;
  }

  Iterable<Token> generateTokens() sync* {
    while (_currentChar != null) {
      if (whitespace.contains(_currentChar!)) {
        _advance();
      } else if (_currentChar == "." || digits.contains(_currentChar!)) {
        yield _generateNumber();
      } else if (_currentChar == "+") {
        _advance();
        yield Token(TokenType.plus);
      } else if (_currentChar == "-") {
        _advance();
        yield Token(TokenType.minus);
      } else if (_currentChar == "*") {
        _advance();
        yield Token(TokenType.multiply);
      } else if (_currentChar == "/") {
        _advance();
        yield Token(TokenType.divide);
      } else if (_currentChar == "^") {
        _advance();
        yield Token(TokenType.power);
      } else if (_currentChar == "(") {
        _advance();
        yield Token(TokenType.lparen);
      } else if (_currentChar == ")") {
        _advance();
        yield Token(TokenType.rparen);
      } else {
        throw Exception("Illegal Char '$_currentChar'");
      }
    }
  }

  Token _generateNumber() {
    int deciCount = 0;
    String numStr = _currentChar!;
    _advance();

    while (_currentChar != null &&
        (_currentChar == "." || digits.contains(_currentChar!))) {
      if (_currentChar == ".") {
        deciCount += 1;
        if (deciCount > 1) {
          break;
        }
      }
      numStr += _currentChar!;
      _advance();
    }

    if (numStr.startsWith(".")) {
      numStr = "0$numStr";
    }
    if (numStr.endsWith(".")) {
      numStr += "0";
    }
    return Token(TokenType.number, double.parse(numStr));
  }
}

class Parser {
  final Iterator _tokens;
  Token? _currentToken;

  Parser({
    required Iterable<Token> tokens,
  }) : _tokens = tokens.iterator {
    _advance();
  }

  void _advance() {
    _currentToken = _tokens.moveNext() ? _tokens.current : null;
  }

  Node? parse() {
    if (_currentToken == null) {
      return null;
    }
    final Node res = expr();
    if (_currentToken != null) {
      throw Exception("Invalid Syntax");
    }
    return res;
  }

  // Captures + and -
  Node expr() {
    Node res = term();

    while (_currentToken != null &&
        [TokenType.plus, TokenType.minus].contains(_currentToken!.type)) {
      if (_currentToken!.type == TokenType.plus) {
        _advance();
        res = BinOpNode(res, "+", term());
      } else if (_currentToken!.type == TokenType.minus) {
        _advance();
        res = BinOpNode(res, "-", term());
      }
    }
    return res;
  }

  // Captures * and /
  Node term() {
    Node res = factor();

    while (_currentToken != null &&
        [TokenType.multiply, TokenType.divide].contains(_currentToken!.type)) {
      if (_currentToken!.type == TokenType.multiply) {
        _advance();
        res = BinOpNode(res, "*", factor());
      } else if (_currentToken!.type == TokenType.divide) {
        _advance();
        res = BinOpNode(res, "/", factor());
      }
    }

    return res;
  }

  //Captures Power
  Node factor() {
    Node res = atom();

    while (_currentToken != null && _currentToken!.type == TokenType.power) {
      _advance();
      res = BinOpNode(res, "^", atom());
    }

    return res;
  }

  // Captures Numbers, UnaryMinus and Params
  Node atom() {
    Token number = _currentToken!;

    if (_currentToken!.type == TokenType.lparen) {
      _advance();
      Node res = expr();
      if (_currentToken!.type != TokenType.rparen) {
        throw Exception("Invalid Syntax");
      }
      _advance();
      return res;
    } else if (_currentToken!.type == TokenType.number) {
      _advance();
      return NumberNode(number.value);
    } else if (_currentToken!.type == TokenType.plus) {
      _advance();
      return PlusNode(factor());
    } else if (_currentToken!.type == TokenType.minus) {
      _advance();
      return MinusNode(factor());
    }
    throw Exception("Invalid Syntax");
  }
}

class Interpreter {
  Number visit(Node? node) {
    if (node is NumberNode) {
      return visitNumberNode(node);
    } else if (node is PlusNode) {
      return visitPlusNode(node);
    } else if (node is MinusNode) {
      return visitMinusNode(node);
    } else if (node is BinOpNode) {
      return visitBinOpNode(node);
    }
    return Number(0);
  }

  Number visitNumberNode(NumberNode node) {
    return Number(node.value);
  }

  Number visitPlusNode(PlusNode node) {
    return Number(visit(node.node).value);
  }

  Number visitMinusNode(MinusNode node) {
    return Number(-visit(node.node).value);
  }

  Number visitBinOpNode(BinOpNode node) {
    if (node.op == "+") {
      return Number(visit(node.a).value + visit(node.b).value);
    } else if (node.op == "-") {
      return Number(visit(node.a).value - visit(node.b).value);
    } else if (node.op == "*") {
      return Number(visit(node.a).value * visit(node.b).value);
    } else if (node.op == "/") {
      try {
        return Number(visit(node.a).value / visit(node.b).value);
      } on Exception {
        throw Exception("Runtime Error");
      }
    } else if (node.op == "^") {
      return Number(pow(visit(node.a).value, visit(node.b).value).toDouble());
    }
    return Number(0);
  }
}
