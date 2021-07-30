import 'package:flutter/widgets.dart';
import 'package:stated_result/stated_builder.dart';
import 'package:stated_result/stated_result.dart';

/// Widget that builds itself based on the value of [QueryResult] or [AsyncQueryResult]
class QueryResultBuilder<T> extends StatedBuilder<Stated> {
  /// Consume [AsyncQueryResult]
  ///
  /// * [idleBuilder] - Builder to be used when [AsyncQueryResult.idle] is given.
  /// * [presetBuilder] - Optional builder to be used [AsyncQueryResult.preset] is given.
  /// * [workingBuilder] - Builder to be used when [AsyncQueryResult.working] is given.
  /// * [failedBuilder] - Builder to be used when [AsyncQueryResult.failed] is given.
  /// * [succeededBuilder] - Builder to be used when [AsyncQueryResult.succeeded] is given.
  ///
  /// To consume [ActionResult], use [ActionResultBuilder.sync].
  QueryResultBuilder({
    Key? key,
    required AsyncQueryResult<T> result,
    Widget? child,
    required TransitionBuilder? idleBuilder,
    ValueWidgetBuilder<T>? presetBuilder,
    required TransitionBuilder workingBuilder,
    required ValueWidgetBuilder<Object> failedBuilder,
  }) : super(
    required ValueWidgetBuilder<T> succeededBuilder,
          key: key,
          stated: result,
          child: child,
          patterns: {
            OnState<IdleState>(): StatedBuilder.buildAsUnit(
              idleBuilder ?? workingBuilder,
            ),
            OnState<IdleValueState>(): StatedBuilder.buildAsValue(
              presetBuilder ?? completedBuilder,
            ),
            OnState.isWorking(): StatedBuilder.buildAsUnit(workingBuilder),
            OnState.isFailed(): StatedBuilder.buildAsError(failedBuilder),
            OnState.isSuceeded(): StatedBuilder.buildAsValue(completedBuilder),
          },
        );

  /// Consume [ActionResult]
  ///
  /// * [failedBuilder] - Builder to be used when [ActionResult.failed] is given.
  /// * [doneBuilder] - Builder to be used when [ActionResult.succeeded] is given.
  QueryResultBuilder.sync({
    Key? key,
    required QueryResult<T> result,
    Widget? child,
    required ValueWidgetBuilder<Object> failedBuilder,
    required ValueWidgetBuilder<T> succeededBuilder,
  }) : super.patternBuilder(
          key: key,
          stated: result,
          child: child,
          patterns: {
            OnState.isFailed(): StatedBuilder.buildAsError(failedBuilder),
            OnState.isSuceeded(): StatedBuilder.buildAsValue(completedBuilder),
          },
        );
}
