import 'dart:io';

import 'package:math_eval/math_eval.dart';
import 'package:math_eval/nodes.dart';
import 'package:math_eval/tokens.dart';
import 'package:math_eval/values.dart';

void main(List<String> arguments) {
  while (true) {
    stdout.write("Calc > ");
    String line = stdin.readLineSync() ?? "";
    Lexer lexer = Lexer(text: line);
    Iterable<Token> tokens = lexer.generateTokens();
    // print(tokens);
    Parser parser = Parser(tokens: tokens);
    Node? root = parser.parse();
    // print(tree);
    Interpreter interpreter = Interpreter();
    Number res = interpreter.visit(root);
    print(res);
  }
}
