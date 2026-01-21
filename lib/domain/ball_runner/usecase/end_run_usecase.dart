import 'package:injectable/injectable.dart';
import 'package:ball_game/domain/ball_runner/entity/run_result_entity.dart';

@injectable
class EndRunUseCase {
  RunResultEntity call({
    required double score,
    required double duration,
    required RunEndedReason reason,
  }) {
    return RunResultEntity(
      score: score,
      duration: duration,
      endedReason: reason,
    );
  }
}
