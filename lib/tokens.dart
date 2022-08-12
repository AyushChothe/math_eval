const whitespace = [" ", "\n", "\t"];
const digits = "0123456789";

enum TokenType { number, plus, minus, multiply, divide, power, lparen, rparen }

class Token {
  TokenType type;
  dynamic value;

  Token(this.type, [this.value]);

  @override
  String toString() {
    return "${type.name}${value != null ? ':$value' : ''}";
  }
}
