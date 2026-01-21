import 'package:freezed_annotation/freezed_annotation.dart';

part 'ball_entity.freezed.dart';

@freezed
abstract class BallEntity with _$BallEntity {
  const factory BallEntity({
    required double y,
    required double velocityY,
    required bool grounded,
  }) = _BallEntity;
}
