import 'package:freezed_annotation/freezed_annotation.dart';

part 'platform_entity.freezed.dart';

@freezed
abstract class PlatformEntity with _$PlatformEntity {
  const factory PlatformEntity({
    required double x,
    required double y,
    required double width,
    required double height,
  }) = _PlatformEntity;
}
