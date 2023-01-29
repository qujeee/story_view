import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CustomIgnorePointer extends SingleChildRenderObjectWidget {
  /// Creates a widget that is invisible to hit testing.
  ///
  /// The [ignoring] argument must not be null. If [ignoringSemantics] is null,
  /// this render object will be ignored for semantics if [ignoring] is true.
  const CustomIgnorePointer({
    super.key,
    this.onIgnore,
    this.ignoring = true,
    this.ignoringSemantics,
    super.child,
  });
  final VoidCallback? onIgnore;

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
  CustomRenderIgnorePointer createRenderObject(BuildContext context) {
    return CustomRenderIgnorePointer(
      onRenderIgnore: () => onIgnore!(),
      ignoring: ignoring,
      ignoringSemantics: ignoringSemantics,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, CustomRenderIgnorePointer renderObject) {
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

class CustomRenderIgnorePointer extends RenderProxyBox {
  /// Creates a render object that is invisible to hit testing.
  ///
  /// The [ignoring] argument must not be null. If [ignoringSemantics] is null,
  /// this render object will be ignored for semantics if [ignoring] is true.
  CustomRenderIgnorePointer({
    RenderBox? child,
    bool ignoring = true,
    this.onRenderIgnore,
    bool? ignoringSemantics,
  })  : _ignoring = ignoring,
        _ignoringSemantics = ignoringSemantics,
        super(child);

  final VoidCallback? onRenderIgnore;

  /// Whether this render object is ignored during hit testing.
  ///
  /// Regardless of whether this render object is ignored during hit testing, it
  /// will still consume space during layout and be visible during painting.
  bool get ignoring => _ignoring;
  bool _ignoring;
  set ignoring(bool value) {
    if (value == _ignoring) {
      return;
    }
    _ignoring = value;
    if (_ignoringSemantics == null || !_ignoringSemantics!) {
      markNeedsSemanticsUpdate();
    }
  }

  /// Whether the semantics of this render object is ignored when compiling the semantics tree.
  ///
  /// If null, defaults to value of [ignoring].
  ///
  /// See [SemanticsNode] for additional information about the semantics tree.
  bool? get ignoringSemantics => _ignoringSemantics;
  bool? _ignoringSemantics;
  set ignoringSemantics(bool? value) {
    if (value == _ignoringSemantics) {
      return;
    }
    final bool oldEffectiveValue = _effectiveIgnoringSemantics;
    _ignoringSemantics = value;
    if (oldEffectiveValue != _effectiveIgnoringSemantics) {
      markNeedsSemanticsUpdate();
    }
  }

  bool get _effectiveIgnoringSemantics => ignoringSemantics ?? ignoring;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    onRenderIgnore!();

    return !ignoring && super.hitTest(result, position: position);
  }

  // TODO(ianh): figure out a way to still include labels and flags in
  // descendants, just make them non-interactive, even when
  // _effectiveIgnoringSemantics is true
  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    if (child != null && !_effectiveIgnoringSemantics) {
      visitor(child!);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('ignoring', ignoring));
    properties.add(
      DiagnosticsProperty<bool>(
        'ignoringSemantics',
        _effectiveIgnoringSemantics,
        description: ignoringSemantics == null
            ? 'implicitly $_effectiveIgnoringSemantics'
            : null,
      ),
    );
  }
}
