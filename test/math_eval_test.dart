import 'package:math_eval/math_eval.dart';
import 'package:math_eval/values.dart';
import 'package:test/test.dart';

void main() {
  Number eval(String text) {
    return Interpreter()
        .visit(Parser(tokens: Lexer(text: text).generateTokens()).parse());
  }

  group("Addition", () {
    test('1+2+3', () {
      Number res = eval("1+2+3");
      expect(res.value, 6.0);
    });
    test('3.14 + 2.2 + 5.6 + 1.9', () {
      Number res = eval("3.14 + 2.2 + 5.6 + 1.9");
      expect(res.value, 12.84);
    });
  });
  group("Substraction", () {
    test('1-2-3', () {
      Number res = eval("1-2-3");
      expect(res.value, -4);
    });
    test('3.14 - 2.2 - 5.6 - 1.89', () {
      Number res = eval("3.14 - 2.2 - 5.6 - 1.89");
      expect(res.value, -6.55);
    });
  });
  group("Multiply", () {
    test('1*2*3', () {
      Number res = eval("1*2*3");
      expect(res.value, 6);
    });
    test('3.14 * 2.2 * 5.6 * 1.9', () {
      Number res = eval("3.14 * 2.2 * 5.6 * 1.9");
      expect(res.value, 73.50112);
    });
  });
  group("Divide", () {
    test('22/7/2', () {
      Number res = eval("22/7/2");
      expect(res.value, 1.5714285714285714);
    });
    test('3.14 / 2.2 / 5.6 / 1.9', () {
      Number res = eval("3.14 / 2.2 / 5.6 / 1.9");
      expect(res.value, 0.1341421736158578);
    });
  });
  group("Mix", () {
    test('(22*3+7)/2-1', () {
      Number res = eval("(22*3+7)/2-1");
      expect(res.value, 35.5);
    });
    test('(2-(-(22/7)*(3.14))/2)', () {
      Number res = eval("(2-(-(22/7)*(3.14))/2)");
      expect(res.value, 6.934285714285714);
    });
  });
}
