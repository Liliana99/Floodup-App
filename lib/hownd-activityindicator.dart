// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const double _kDefaultIndicatorRadius = 24.0;

/// An iOS-style activity indicator.
///
/// See also:
///
///  * <https://developer.apple.com/ios/human-interface-guidelines/controls/progress-indicators/#activity-indicators>
class HOWNDActivityIndicator extends StatefulWidget {
  /// Creates an iOS-style activity indicator.
  const HOWNDActivityIndicator({
    Key key,
    this.animating = true,
    this.radius = _kDefaultIndicatorRadius,
  })  : assert(animating != null),
        assert(radius != null),
        assert(radius > 0),
        super(key: key);

  /// Whether the activity indicator is running its animation.
  ///
  /// Defaults to true.
  final bool animating;

  /// Radius of the spinner widget.
  ///
  /// Defaults to 10px. Must be positive and cannot be null.
  final double radius;

  @override
  _HOWNDActivityIndicatorState createState() => _HOWNDActivityIndicatorState();
}

class _HOWNDActivityIndicatorState extends State<HOWNDActivityIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.animating) _controller.repeat();
  }

  @override
  void didUpdateWidget(HOWNDActivityIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      if (widget.animating)
        _controller.repeat();
      else
        _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: CustomPaint(
        painter: _HOWNDActivityIndicatorPainter(
          position: _controller,
          radius: widget.radius,
        ),
      ),
    );
  }
}

const double _kTwoPI = math.pi * 2.0;
const int _kTickCount = 8;
const int _kHalfTickCount = _kTickCount ~/ 2;
const Color _kTickColor = Color(0xff00254a);
const Color _kActiveTickColor = Colors.blue;

class _HOWNDActivityIndicatorPainter extends CustomPainter {
  _HOWNDActivityIndicatorPainter({
    this.position,
    double radius,
  })  : tickFundamentalRRect = RRect.fromLTRBXY(
          -radius,
          1.0 * radius / _kDefaultIndicatorRadius - 2.5,
          -radius / 2.0,
          -1.0 * radius / _kDefaultIndicatorRadius + 2.5,
          1.0,
          1.0,
        ),
        super(repaint: position);

  final Animation<double> position;
  final RRect tickFundamentalRRect;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);

    final int activeTick = (_kTickCount * position.value).floor();

    for (int i = 0; i < _kTickCount; ++i) {
      final double t =
          (((i + activeTick) % _kTickCount) / _kHalfTickCount).clamp(0.0, 1.0);
      paint.color = Color.lerp(_kActiveTickColor, _kTickColor, t);
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(-_kTwoPI / _kTickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_HOWNDActivityIndicatorPainter oldPainter) {
    return oldPainter.position != position;
  }
}
