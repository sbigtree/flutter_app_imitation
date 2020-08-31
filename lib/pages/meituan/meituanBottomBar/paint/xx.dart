import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



abstract class MyImplicitlyAnimatedWidget extends StatefulWidget {
  /// Initializes fields for subclasses.
  ///
  /// The [curve] and [duration] arguments must not be null.
  const MyImplicitlyAnimatedWidget({
    Key key,
    this.curve = Curves.linear,
    @required this.duration,
    this.onEnd,
  }) : assert(curve != null),
        assert(duration != null),
        super(key: key);

  /// The curve to apply when animating the parameters of this container.
  final Curve curve;

  /// The duration over which to animate the parameters of this container.
  final Duration duration;

  /// Called every time an animation completes.
  ///
  /// This can be useful to trigger additional actions (e.g. another animation)
  /// at the end of the current animation.
  final VoidCallback onEnd;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('duration', duration.inMilliseconds, unit: 'ms'));
  }
}

abstract class MyImplicitlyAnimatedWidgetState<T extends ImplicitlyAnimatedWidget>
    extends State<T> with SingleTickerProviderStateMixin<T> {
  /// The animation controller driving this widget's implicit animations.
  @protected
  AnimationController get controller => _controller;
  AnimationController _controller;

  /// The animation driving this widget's implicit animations.
  Animation<double> get animation => _animation;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      debugLabel: kDebugMode ? widget.toStringShort() : null,
      vsync: this,
    );
    _controller.addStatusListener((AnimationStatus status) {
      switch (status) {
        case AnimationStatus.completed:
          if (widget.onEnd != null) widget.onEnd();
          break;
        case AnimationStatus.dismissed:
        case AnimationStatus.forward:
        case AnimationStatus.reverse:
      }
    });
    _updateCurve();
    _constructTweens();
    didUpdateTweens();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.curve != oldWidget.curve) _updateCurve();
    _controller.duration = widget.duration;
    if (_constructTweens()) {
      forEachTween((Tween<dynamic> tween, dynamic targetValue,
          TweenConstructor<dynamic> constructor) {
        _updateTween(tween, targetValue);
        return tween;
      });
      _controller
        ..value = 0.0
        ..forward();
      didUpdateTweens();
    }
  }

  void _updateCurve() {
    if (widget.curve != null)
      _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    else
      _animation = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _shouldAnimateTween(Tween<dynamic> tween, dynamic targetValue) {
    return targetValue != (tween.end ?? tween.begin);
  }

  void _updateTween(Tween<dynamic> tween, dynamic targetValue) {
    if (tween == null) return;
    tween
      ..begin = tween.evaluate(_animation)
      ..end = targetValue;
  }

  bool _constructTweens() {
    bool shouldStartAnimation = false;
    forEachTween((Tween<dynamic> tween, dynamic targetValue,
        TweenConstructor<dynamic> constructor) {
      if (targetValue != null) {
        tween ??= constructor(targetValue);
        if (_shouldAnimateTween(tween, targetValue))
          shouldStartAnimation = true;
      } else {
        tween = null;
      }
      return tween;
    });
    return shouldStartAnimation;
  }

  /// Visits each tween controlled by this state with the specified `visitor`
  /// function.
  ///
  /// ### Subclass responsibility
  ///
  /// Properties to be animated are represented by [Tween] member variables in
  /// the state. For each such tween, [forEachTween] implementations are
  /// expected to call `visitor` with the appropriate arguments and store the
  /// result back into the member variable. The arguments to `visitor` are as
  /// follows:
  ///
  /// {@macro flutter.widgets.implicit_animations.tweenVisitorArguments}
  ///
  /// ### When this method will be called
  ///
  /// [forEachTween] is initially called during [initState]. It is expected that
  /// the visitor's `tween` argument will be set to null, causing the visitor to
  /// call its `constructor` argument to construct the tween for the first time.
  /// The resulting tween will have its `begin` value set to the target value
  /// and will have its `end` value set to null. The animation will not be
  /// started.
  ///
  /// When this state's [widget] is updated (thus triggering the
  /// [didUpdateWidget] method to be called), [forEachTween] will be called
  /// again to check if the target value has changed. If the target value has
  /// changed, signaling that the [animation] should start, then the visitor
  /// will update the tween's `start` and `end` values accordingly, and the
  /// animation will be started.
  ///
  /// ### Other member variables
  ///
  /// Subclasses that contain properties based on tweens created by
  /// [forEachTween] should override [didUpdateTweens] to update those
  /// properties. Dependent properties should not be updated within
  /// [forEachTween].
  ///
  /// {@tool snippet}
  ///
  /// This sample implements an implicitly animated widget's `State`.
  /// The widget animates between colors whenever `widget.targetColor`
  /// changes.
  ///
  /// ```dart
  /// class MyWidgetState extends AnimatedWidgetBaseState<MyWidget> {
  ///   ColorTween _colorTween;
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Text(
  ///       'Hello World',
  ///       // Computes the value of the text color at any given time.
  ///       style: TextStyle(color: _colorTween.evaluate(animation)),
  ///     );
  ///   }
  ///
  ///   @override
  ///   void forEachTween(TweenVisitor<dynamic> visitor) {
  ///     // Update the tween using the provided visitor function.
  ///     _colorTween = visitor(
  ///       // The latest tween value. Can be `null`.
  ///       _colorTween,
  ///       // The color value toward which we are animating.
  ///       widget.targetColor,
  ///       // A function that takes a color value and returns a tween
  ///       // beginning at that value.
  ///       (value) => ColorTween(begin: value),
  ///     );
  ///
  ///     // We could have more tweens than one by using the visitor
  ///     // multiple times.
  ///   }
  /// }
  /// ```
  /// {@end-tool}
  @protected
  void forEachTween(TweenVisitor<dynamic> visitor);

  /// Optional hook for subclasses that runs after all tweens have been updated
  /// via [forEachTween].
  ///
  /// Any properties that depend upon tweens created by [forEachTween] should be
  /// updated within [didUpdateTweens], not within [forEachTween].
  ///
  /// This method will be called both:
  ///
  ///  1. After the tweens are _initially_ constructed (by
  ///     the `constructor` argument to the [TweenVisitor] that's passed to
  ///     [forEachTween]). In this case, the tweens are likely to contain only
  ///     a [Tween.begin] value and not a [Tween.end].
  ///
  ///  2. When the state's [widget] is updated, and one or more of the tweens
  ///     visited by [forEachTween] specifies a target value that's different
  ///     than the widget's current value, thus signaling that the [animation]
  ///     should run. In this case, the [Tween.begin] value for each tween will
  ///     an evaluation of the tween against the current [animation], and the
  ///     [Tween.end] value for each tween will be the target value.
  @protected
  void didUpdateTweens() {}
}
