part of 'stats_cubit.dart';

@freezed
sealed class StatsState with _$StatsState {
  const factory StatsState.loading() = StatsLoading;
  const factory StatsState.data({
    required List<int> scores,
    required int record,
  }) = StatsData;
  const factory StatsState.empty() = StatsEmpty;
  const factory StatsState.error({required String message}) = StatsError;
}
