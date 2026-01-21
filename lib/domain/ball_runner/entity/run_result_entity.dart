import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_result_entity.freezed.dart';

enum RunEndedReason { fell }

@freezed
abstract class RunResultEntity with _$RunResultEntity {
  const factory RunResultEntity({
    required double score,
    required double duration,
    required RunEndedReason endedReason,
  }) = _RunResultEntity;
}
