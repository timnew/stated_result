import 'package:flutter/widgets.dart';

import 'default_busy_result_builder.dart';
import 'default_failed_result_builder.dart';
import 'default_pending_result_builder.dart';
import 'function_types.dart';

class DefaultResultBuilder extends StatelessWidget {
  final WidgetBuilder? pendingBuilder;
  final WidgetBuilder? busyBuilder;
  final FailedResultBuilder? failedBuilder;
  final Widget child;

  const DefaultResultBuilder({
    Key? key,
    this.pendingBuilder,
    this.busyBuilder,
    this.failedBuilder,
    required this.child,
  })   : assert(
          pendingBuilder != null ||
              busyBuilder != null ||
              failedBuilder != null,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    if (failedBuilder != null) {
      result =
          DefaultFailedResultBuilder(builder: failedBuilder!, child: result);
    }

    if (busyBuilder != null) {
      result = DefaultBusyResultBuilder(builder: busyBuilder!, child: result);
    }

    if (failedBuilder != null) {
      result =
          DefaultPendingResultBuilder(builder: pendingBuilder!, child: result);
    }

    return result;
  }

  static void setGlobalBuilder({
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? busyBuilder,
    FailedResultBuilder? failedBuilder,
  }) {
    if (pendingBuilder != null) {
      DefaultPendingResultBuilder.globalBuilder = pendingBuilder;
    }

    if (busyBuilder != null) {
      DefaultBusyResultBuilder.globalBuilder = busyBuilder;
    }

    if (failedBuilder != null) {
      DefaultFailedResultBuilder.globalBuilder = failedBuilder;
    }
  }
}
