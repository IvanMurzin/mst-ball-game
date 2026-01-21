import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:ball_game/domain/ball_runner/entity/ball_entity.dart';
import 'package:ball_game/domain/ball_runner/entity/platform_entity.dart';

class StartRunResult {
  const StartRunResult({
    required this.ball,
    required this.platforms,
    required this.score,
    required this.elapsed,
  });

  final BallEntity ball;
  final List<PlatformEntity> platforms;
  final double score;
  final double elapsed;
}

@injectable
class StartRunUseCase {
  final Random _random = Random();

  StartRunResult call({
    required double fieldWidth,
    required double fieldHeight,
  }) {
    final radius = _ballRadius(fieldWidth, fieldHeight);
    final platformHeight = _platformHeight(fieldHeight);
    final platformTop = _platformTop(fieldHeight);
    final initialWidth = _platformWidth(fieldWidth);

    final platforms = <PlatformEntity>[
      PlatformEntity(
        x: 0,
        y: platformTop,
        width: initialWidth,
        height: platformHeight,
      ),
    ];

    var cursor = initialWidth;
    for (var i = 0; i < 2; i++) {
      final gap = _platformGap(fieldWidth);
      final width = _platformWidth(fieldWidth);
      final top = _platformTop(fieldHeight);
      final x = cursor + gap;
      platforms.add(
        PlatformEntity(x: x, y: top, width: width, height: platformHeight),
      );
      cursor = x + width;
    }

    final ball = BallEntity(
      y: platformTop - radius,
      velocityY: 0,
      grounded: true,
    );

    return StartRunResult(
      ball: ball,
      platforms: platforms,
      score: 0,
      elapsed: 0,
    );
  }

  double _ballRadius(double fieldWidth, double fieldHeight) {
    return ((fieldWidth + fieldHeight) * 0.015).clamp(10.0, 18.0);
  }

  double _platformHeight(double fieldHeight) {
    return (fieldHeight * 0.08).clamp(12.0, 24.0);
  }

  double _platformTop(double fieldHeight) {
    final base = fieldHeight * 0.7;
    final variance = fieldHeight * 0.06;
    final value = base + _randomBetween(-variance, variance);
    return value.clamp(fieldHeight * 0.55, fieldHeight * 0.8);
  }

  double _platformGap(double fieldWidth) {
    final minGap = (fieldWidth * 0.12).clamp(35.0, 90.0);
    final maxGap = minGap * 1.35;
    return _randomBetween(minGap, maxGap);
  }

  double _platformWidth(double fieldWidth) {
    final minWidth = max(70.0, fieldWidth * 0.35);
    final targetMax = max(minWidth, fieldWidth * 0.65);
    final maxWidth = max(minWidth, min(fieldWidth * 0.9, targetMax));
    return _randomBetween(minWidth, maxWidth);
  }

  double _randomBetween(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }
}
