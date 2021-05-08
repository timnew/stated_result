import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated.dart';

void main() {
  group("DoneState", () {
    const state = DoneState();

    test("it has correct state", () {
      expect(state.isIdle, isFalse);
      expect(state.isWorking, isFalse);
      expect(state.isFinished, isTrue);
      expect(state.isSucceeded, isTrue);
      expect(state.isFailed, isFalse);
      expect(state.hasValue, isFalse);
      expect(state.hasError, isFalse);
    });

    test("it should equals to each other", () {
      expect(state, DoneState());
    });
  });
}
