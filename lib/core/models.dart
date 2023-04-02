import 'dart:math';
import 'package:flutter/material.dart';

class Prediction {
  final BoundingBox rect;
  final double confidence; // between 0 and 1
  final String object;
  Color color;
  Prediction({
    required this.rect,
    required this.confidence,
    required this.object,
  }) : color =
            Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  Prediction.fromJson(json)
      : rect = BoundingBox.fromJson(json['rect'] ?? {}),
        confidence = json['confidenceInClass'] ?? 0.0,
        object = json['detectedClass'] ?? "unknown",
        color =
            Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}

/// [height], [widhth], [x], and [y] are between 0 and 1, we later scale them up according to image size
class BoundingBox {
  final double width;
  final double height;
  final double x;
  final double y;
  const BoundingBox(
      {required this.width,
      required this.height,
      required this.x,
      required this.y});

  BoundingBox.fromJson(json)
      : width = json['w'] ?? 0.0,
        height = json['h'] ?? 0.0,
        x = json['x'] ?? 0.0,
        y = json['y'] ?? 0.0;
}
