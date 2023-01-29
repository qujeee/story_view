import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomIgnorePointer extends SingleChildRenderObjectWidget {
  /// Creates a widget that is invisible to hit testing.
  ///
  /// The [ignoring] argument must not be null. If [ignoringSemantics] is null,
  /// this render object will be ignored for semantics if [ignoring] is true.
  const CustomIgnorePointer(
    this.onChange, {
    super.key,
    this.ignoring = true,
    this.ignoringSemantics,
    super.child,
  });

  final ValueChanged onChange;

  /// Whether this widget is ignored during hit testing.
  ///
  /// Regardless of whether this widget is ignored during hit testing, it will
  /// still consume space during layout and be visible during painting.
  final bool ignoring;

  /// Whether the semantics of this widget is ignored when compiling the semantics tree.
  ///
  /// If null, defaults to value of [ignoring].
  ///
  /// See [SemanticsNode] for additional information about the semantics tree.
  final bool? ignoringSemantics;

  @override
  RenderIgnorePointer createRenderObject(BuildContext context) {
    return RenderIgnorePointer(
      ignoring: ignoring,
      ignoringSemantics: ignoringSemantics,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderIgnorePointer renderObject) {
    renderObject
      ..ignoring = ignoring
      ..ignoringSemantics = ignoringSemantics;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('ignoring', ignoring));
    properties.add(DiagnosticsProperty<bool>(
        'ignoringSemantics', ignoringSemantics,
        defaultValue: null));
  }
}
