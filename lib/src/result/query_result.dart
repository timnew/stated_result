import 'dart:async';

import 'package:stated_result/stated.dart';

import 'action_result.dart';
import 'async_action_result.dart';
import 'async_query_result.dart';

/// A type represents the result of an query.
///
/// [QueryResult.completed] creates the [SucceededValueState], indicates the action is completed
/// [QueryResult.failed] creates the [FailedState], indicates the action is failed
///
/// See also
/// * [ActionResult]
/// * [AsyncActionResult]
/// * [AsyncQueryResult]
abstract class QueryResult<T> implements Stated {
  /// Alias to [QueryResult.completed]
  const factory QueryResult(T value) = QueryResult.completed;

  /// creates an [QueryResult] in [SucceededValueState] holds [value]
  const factory QueryResult.completed(T value) = _Completed;

  /// creates an [QueryResult] in [FailedState] with [error]
  const factory QueryResult.failed(Object error) = _Failed;

  /// Create [QueryResult] from other [Stated] types
  /// * [SucceededValueState] converts to [QueryResult.completed]
  /// * [FailedState] or [FailedValueState] converts to [QueryResult.failed]
  ///  Otherwise [UnsupportedError] is thrown
  factory QueryResult.from(Stated other) {
    if (other is SucceededValueState<T>)
      return QueryResult.completed(other.value);
    if (other is HasError) return QueryResult.failed(other.extractError());
    throw UnsupportedError("$other in the state not supported by QueryResult");
  }

  /// Pattern match the result
  ///
  /// [completed] is called with value if result is succeeded
  /// [failed] is called with error and stackTrace if result is failed
  TR map<TR>({
    required ValueTransformer<T, TR> completed,
    required ValueTransformer<Object, TR> failed,
  }) {
    if (this is _Completed) return completed(this.extractValue());
    return failed(this.extractError());
  }
}

class _Completed<T> extends SucceededValueState<T> with QueryResult<T> {
  const _Completed(T value) : super(value);
}

class _Failed<T> extends FailedState with QueryResult<T> {
  const _Failed(Object error) : super(error);
}

/// Provides extension methods on `Future<T>` for [QueryResult]
extension QueryResultFutureExtension<T> on Future<T> {
  /// Materialize `Future<T>` into `Future<QueryResut<T>>`]
  ///
  /// Materialised future always succeed unless future throws error
  /// Returns [QueryResult.completed] if future resovled succesfully
  /// Returns [QueryResult.failed] if future throws exception
  Future<QueryResult<T>> asQueryResult() async {
    try {
      return QueryResult.completed(await this);
    } on Error {
      rethrow;
    } catch (exception) {
      return QueryResult.failed(exception);
    }
  }
}
