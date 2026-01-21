part of 'game_cubit.dart';

@freezed
sealed class GameState with _$GameState {
  const factory GameState.idle() = GameIdle;
  const factory GameState.running({
    required double ballY,
    required double ballVelocityY,
    required bool grounded,
    required List<PlatformEntity> platforms,
    required double score,
    required double elapsed,
  }) = GameRunning;
  const factory GameState.gameOver({
    required double finalScore,
    required double duration,
    required RunEndedReason reason,
  }) = GameGameOver;
  const factory GameState.error({
    required String message,
  }) = GameError;
}
