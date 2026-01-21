part of 'skins_cubit.dart';

@freezed
sealed class SkinsState with _$SkinsState {
  const factory SkinsState.loading() = SkinsLoading;
  const factory SkinsState.ready({required BallSkin selected}) = SkinsReady;
  const factory SkinsState.error({required String message}) = SkinsError;
}
