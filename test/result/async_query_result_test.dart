import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

void main() {
  group("AsyncQueryResult", () {
    final value = "value";
    group("default constructor", () {
      final result = AsyncQueryResult<String>();

      test('should be a PendingResult', () {
        expect(result, isInstanceOf<PendingResult>());
      });

      test('gives the same instance', () {
        expect(AsyncQueryResult(), same(result));
      });

      test("should have correct states", () {
        expect(result.isNotStarted, isTrue);
        expect(result.isBusy, isFalse);
        expect(result.isFinished, isFalse);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isFalse);
        expect(() => result.ensureNotBusy(), returnsNormally);
      });
    });

    group(".initialValue", () {
      final result = AsyncQueryResult.initialValue(value);

      test('should be a CompletedResult', () {
        expect(result, isInstanceOf<InitialValueResult<String>>());
      });

      test("should has value", () {
        final succeeded = result as InitialValueResult<String>;
        expect(value, succeeded.value);
      });

      test("should have correct states", () {
        expect(result.isNotStarted, isTrue);
        expect(result.isBusy, isFalse);
        expect(result.isFinished, isFalse);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isTrue);
        expect(() => result.ensureNotBusy(), returnsNormally);
      });
    });

    group(".busy", () {
      final result = AsyncQueryResult.busy();

      test('should be a BusyResult', () {
        expect(result, isInstanceOf<BusyResult>());
      });

      test('gives the same instance', () {
        expect(AsyncQueryResult.busy(), same(result));
      });

      test("should have correct states", () {
        expect(result.isNotStarted, isFalse);
        expect(result.isBusy, isTrue);
        expect(result.isFinished, isFalse);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isFalse);
        expect(() => result.ensureNotBusy(), throwsStateError);
      });
    });

    group(".succeeded", () {
      final result = AsyncQueryResult.succeeded(value);

      test('should be a CompletedResult', () {
        expect(result, isInstanceOf<SucceededResult<String>>());
      });

      test("should has value", () {
        final succeeded = result as SucceededResult<String>;
        expect(value, succeeded.value);
      });

      test("should have correct states", () {
        expect(result.isNotStarted, isFalse);
        expect(result.isBusy, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isTrue);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isTrue);
        expect(() => result.ensureNotBusy(), returnsNormally);
      });
    });

    group(".failed", () {
      final error = Exception("test error");
      final stackTrace = StackTrace.empty;

      final result = AsyncQueryResult.failed(error, stackTrace);

      test('should be a FailedResult', () {
        expect(result, isInstanceOf<FailedResult>());
      });

      test('should contain error and stack trace', () {
        final failed = result as FailedResult;

        expect(failed.error, same(error));
        expect(failed.stackTrace, same(stackTrace));
      });

      test('can create result without stacktrace', () {
        final failed = AsyncQueryResult.failed(error) as FailedResult;

        expect(failed.error, same(error));
        expect(failed.stackTrace, isNull);
      });

      test("should have correct states", () {
        expect(result.isNotStarted, isFalse);
        expect(result.isBusy, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isTrue);
        expect(result.hasValue, isFalse);
        expect(() => result.ensureNotBusy(), returnsNormally);
      });
    });
  });
}
