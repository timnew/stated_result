import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

void main() {
  group("AsyncActionResult", () {
    final error = "error";

    group("default constructor", () {
      final result = AsyncActionResult();

      test('should be a PendingResult', () {
        expect(result, isInstanceOf<PendingResult>());
      });

      test('gives the same instance', () {
        expect(AsyncActionResult(), same(result));
      });

      test("should have correct states", () {
        expect(result.isNotStarted, isTrue);
        expect(result.isWaiting, isFalse);
        expect(result.isFinished, isFalse);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isFalse);
      });
    });

    group(".waiting", () {
      final result = AsyncActionResult.waiting();

      test('should be a WaitingResult', () {
        expect(result, isInstanceOf<WaitingResult>());
      });

      test('gives the same instance', () {
        expect(AsyncActionResult.waiting(), same(result));
      });

      test("should have correct states", () {
        expect(result.isNotStarted, isFalse);
        expect(result.isWaiting, isTrue);
        expect(result.isFinished, isFalse);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isFalse);
      });
    });

    group(".completed", () {
      final result = AsyncActionResult.completed();

      test('should be a CompletedResult', () {
        expect(result, isInstanceOf<CompletedResult>());
      });

      test('gives the same instance', () {
        expect(AsyncActionResult.completed(), same(result));
      });

      test("should have correct states", () {
        expect(result.isNotStarted, isFalse);
        expect(result.isWaiting, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isTrue);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isFalse);
      });
    });

    group(".failed", () {
      final error = Exception("test error");
      final stackTrace = StackTrace.empty;

      final result = AsyncActionResult.failed(error, stackTrace);

      test('should be a FailedResult', () {
        expect(result, isInstanceOf<FailedResult>());
      });

      test('should contain error and stack trace', () {
        final failed = result as FailedResult;

        expect(failed.error, same(error));
        expect(failed.stackTrace, same(stackTrace));
      });

      test('can create result without stacktrace', () {
        final failed = AsyncActionResult.failed(error) as FailedResult;

        expect(failed.error, same(error));
        expect(failed.stackTrace, isNull);
      });

      test("should have correct states", () {
        expect(result.isNotStarted, isFalse);
        expect(result.isWaiting, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isTrue);
        expect(result.hasValue, isFalse);
      });
    });

    group(".updateWith", () {
      test("should update value with completed", () async {
        final initial = AsyncActionResult.pending();

        final future = Future.value(ActionResult.completed());
        final states = initial.updateWith(future);

        expect(
          states,
          emitsInOrder([
            AsyncActionResult.waiting(),
            AsyncActionResult.completed(),
          ]),
        );
      });
      test("should update value with failed", () async {
        final initial = AsyncActionResult.pending();

        final future = Future.value(ActionResult.failed(error));
        final states = initial.updateWith(future);

        expect(
          states,
          emitsInOrder([
            AsyncActionResult.waiting(),
            AsyncActionResult.failed(error),
          ]),
        );
      });

      test("should complains when call on waiting", () async {
        final initial = AsyncActionResult.waiting();

        final future = Future.value(ActionResult.completed());

        final states = initial.updateWith(future);

        await expectLater(states, emitsError(isInstanceOf<StateError>()));
      });
    });
  });
}
