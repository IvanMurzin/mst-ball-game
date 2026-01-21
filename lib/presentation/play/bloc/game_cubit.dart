import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ball_game/core/logger/logger.dart';
import 'package:ball_game/domain/ball_runner/entity/ball_entity.dart';
import 'package:ball_game/domain/ball_runner/entity/platform_entity.dart';
import 'package:ball_game/domain/ball_runner/entity/run_result_entity.dart';
import 'package:ball_game/domain/ball_runner/usecase/end_run_usecase.dart';
import 'package:ball_game/domain/ball_runner/usecase/jump_usecase.dart';
import 'package:ball_game/domain/ball_runner/usecase/start_run_usecase.dart';
import 'package:ball_game/domain/ball_runner/usecase/tick_run_usecase.dart';

part 'game_cubit.freezed.dart';
part 'game_state.dart';

@injectable
class GameCubit extends Cubit<GameState> {
  GameCubit(
    this._startRunUseCase,
    this._tickRunUseCase,
    this._jumpUseCase,
    this._endRunUseCase,
  ) : super(const GameState.idle());

  final StartRunUseCase _startRunUseCase;
  final TickRunUseCase _tickRunUseCase;
  final JumpUseCase _jumpUseCase;
  final EndRunUseCase _endRunUseCase;

  Timer? _ticker;
  final Stopwatch _stopwatch = Stopwatch();
  Duration _lastTick = Duration.zero;
  Size _fieldSize = Size.zero;
  double _ballX = 0;

  void setFieldSize(Size size) {
    if (size.isEmpty) {
      return;
    }
    _fieldSize = size;
    _ballX = size.width * 0.2;
  }

  void start() {
    if (_fieldSize.isEmpty) {
      logger.w({'event': 'run_start_failed', 'reason': 'field_not_ready'});
      return;
    }
    try {
      _stop();
      _stopwatch.reset();
      _stopwatch.start();
      _lastTick = Duration.zero;

      final result = _startRunUseCase(
        fieldWidth: _fieldSize.width,
        fieldHeight: _fieldSize.height,
      );
      emit(
        GameState.running(
          ballY: result.ball.y,
          ballVelocityY: result.ball.velocityY,
          grounded: result.ball.grounded,
          platforms: result.platforms,
          score: result.score,
          elapsed: result.elapsed,
        ),
      );

      logger.i({
        'event': 'run_start',
        'width': _fieldSize.width,
        'height': _fieldSize.height,
      });

      _ticker = Timer.periodic(
        const Duration(milliseconds: 16),
        (_) => _onTick(),
      );
    } catch (error, stackTrace) {
      _stop();
      logger.e('run_start_error', error: error, stackTrace: stackTrace);
      emit(GameState.error(message: 'Failed to start'));
    }
  }

  void retry() {
    start();
  }

  void onTapJump() {
    final current = state;
    if (current is GameIdle || current is GameError) {
      start();
      return;
    }
    if (current is GameGameOver) {
      retry();
      return;
    }
    if (current is! GameRunning) {
      return;
    }

    final updated = _jumpUseCase(
      ball: BallEntity(
        y: current.ballY,
        velocityY: current.ballVelocityY,
        grounded: current.grounded,
      ),
    );
    emit(
      current.copyWith(
        ballY: updated.y,
        ballVelocityY: updated.velocityY,
        grounded: updated.grounded,
      ),
    );
  }

  void _onTick() {
    final current = state;
    if (current is! GameRunning) {
      return;
    }

    final elapsed = _stopwatch.elapsed;
    final delta = elapsed - _lastTick;
    _lastTick = elapsed;
    var dt = delta.inMicroseconds / 1000000;
    if (dt <= 0) {
      return;
    }
    if (dt > 0.033) {
      dt = 0.033;
    }

    try {
      final result = _tickRunUseCase(
        ball: BallEntity(
          y: current.ballY,
          velocityY: current.ballVelocityY,
          grounded: current.grounded,
        ),
        platforms: current.platforms,
        dt: dt,
        fieldWidth: _fieldSize.width,
        fieldHeight: _fieldSize.height,
        ballX: _ballX,
        score: current.score,
        elapsed: current.elapsed,
      );

      if (result.isGameOver) {
        final runResult = _endRunUseCase(
          score: result.score,
          duration: result.elapsed,
          reason: result.endReason ?? RunEndedReason.fell,
        );
        emit(
          GameState.gameOver(
            finalScore: runResult.score,
            duration: runResult.duration,
            reason: runResult.endedReason,
          ),
        );
        _stop();
        logger.i({
          'event': 'run_end',
          'score': runResult.score,
          'duration': runResult.duration,
          'reason': runResult.endedReason.name,
        });
        return;
      }

      emit(
        GameState.running(
          ballY: result.ball.y,
          ballVelocityY: result.ball.velocityY,
          grounded: result.ball.grounded,
          platforms: result.platforms,
          score: result.score,
          elapsed: result.elapsed,
        ),
      );
    } catch (error, stackTrace) {
      _stop();
      logger.e('run_tick_error', error: error, stackTrace: stackTrace);
      emit(GameState.error(message: 'Simulation error'));
    }
  }

  void _stop() {
    _ticker?.cancel();
    _ticker = null;
    _stopwatch.stop();
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
