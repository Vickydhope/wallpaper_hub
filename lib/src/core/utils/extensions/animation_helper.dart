import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension AnimationHelper on Widget {
  Widget shimmer() {
    return animate(onPlay: (controller) {
      controller.repeat();
    }).shimmer(duration: 1200.ms, color: Colors.grey.shade200, size: 0.7);
  }
}
