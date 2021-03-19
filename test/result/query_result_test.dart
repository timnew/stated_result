import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

void main() {
  group("QueryResult", () {
    group("default constructor", () {
      final result = const QueryResult("value");

      test('should be a CompletedResult', () {
        expect(result, isInstanceOf<SucceededResult<String>>());
      });
      test('gives the same instance', () {
        expect(const QueryResult("value"), same(result));
      });
    });

    group(".failed", () {
      final error = Exception("test error");
      final stackTrace = StackTrace.empty;

      final result = QueryResult.failed(error, stackTrace);

      test('should be a FailedResult', () {
        expect(result, isInstanceOf<FailedResult>());
      });

      test('should contain error and stack trace', () {
        final failed = result as FailedResult;

        expect(failed.error, same(error));
        expect(failed.stackTrace, same(stackTrace));
      });

      test('can create result without stacktrace', () {
        final failed = QueryResult.failed(error) as FailedResult;

        expect(failed.error, same(error));
        expect(failed.stackTrace, isNull);
      });
    });
  });
}
