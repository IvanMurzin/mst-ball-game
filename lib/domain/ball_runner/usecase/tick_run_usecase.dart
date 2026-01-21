import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:ball_game/domain/ball_runner/entity/ball_entity.dart';
import 'package:ball_game/domain/ball_runner/entity/platform_entity.dart';
import 'package:ball_game/domain/ball_runner/entity/run_result_entity.dart';

class TickRunResult {
  const TickRunResult({
    required this.ball,
    required this.platforms,
    required this.score,
    required this.elapsed,
    required this.endReason,
  });

  final BallEntity ball;
  final List<PlatformEntity> platforms;
  final double score;
  final double elapsed;
  final RunEndedReason? endReason;

  bool get isGameOver => endReason != null;
}

@injectable
class TickRunUseCase {
  final Random _random = Random();

  TickRunResult call({
    required BallEntity ball,
    required List<PlatformEntity> platforms,
    required double dt,
    required double fieldWidth,
    required double fieldHeight,
    required double ballX,
    required double score,
    required double elapsed,
  }) {
    final gravity = 900.0;
    final speed = 110.0;
    final scoreRate = 5.0;
    final radius = _ballRadius(fieldWidth, fieldHeight);

    var velocityY = ball.velocityY + gravity * dt;
    var y = ball.y + velocityY * dt;
    final prevY = ball.y;

    final movedPlatforms = platforms
        .map((platform) => platform.copyWith(x: platform.x - speed * dt))
        .where((platform) => platform.x + platform.width > -40)
        .toList();

    if (movedPlatforms.isNotEmpty) {
      final last = movedPlatforms.last;
      if (last.x + last.width < fieldWidth + fieldWidth * 0.6) {
        movedPlatforms.add(_spawnPlatform(fieldWidth, fieldHeight, last));
      }
    } else {
      movedPlatforms.add(
        PlatformEntity(
          x: 0,
          y: _platformTop(fieldHeight),
          width: _platformWidth(fieldWidth),
          height: _platformHeight(fieldHeight),
        ),
      );
    }

    var grounded = false;
    for (final platform in movedPlatforms) {
      final withinX =
          ballX >= platform.x && ballX <= platform.x + platform.width;
      if (!withinX) {
        continue;
      }
      final top = platform.y;
      final wasAbove = prevY + radius <= top;
      final nowBelow = y + radius >= top;
      if (wasAbove && nowBelow && velocityY >= 0) {
        y = top - radius;
        velocityY = 0;
        grounded = true;
        break;
      }
    }

    final endReason = y - radius > fieldHeight ? RunEndedReason.fell : null;

    final updatedBall = ball.copyWith(
      y: y,
      velocityY: velocityY,
      grounded: grounded,
    );

    return TickRunResult(
      ball: updatedBall,
      platforms: movedPlatforms,
      score: score + dt * scoreRate,
      elapsed: elapsed + dt,
      endReason: endReason,
    );
  }

  PlatformEntity _spawnPlatform(
    double fieldWidth,
    double fieldHeight,
    PlatformEntity last,
  ) {
    final gap = _platformGap(fieldWidth);
    final width = _platformWidth(fieldWidth);
    final height = _platformHeight(fieldHeight);
    final top = _platformTop(fieldHeight);
    final x = last.x + last.width + gap;
    return PlatformEntity(x: x, y: top, width: width, height: height);
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
