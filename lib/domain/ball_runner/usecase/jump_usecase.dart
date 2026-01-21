import 'package:injectable/injectable.dart';
import 'package:ball_game/domain/ball_runner/entity/ball_entity.dart';

@injectable
class JumpUseCase {
  BallEntity call({
    required BallEntity ball,
    double jumpVelocity = -520,
  }) {
    if (!ball.grounded) {
      return ball;
    }
    return ball.copyWith(
      velocityY: jumpVelocity,
      grounded: false,
    );
  }
}
