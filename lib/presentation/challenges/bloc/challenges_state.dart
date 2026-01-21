part of 'challenges_cubit.dart';

@freezed
sealed class ChallengesState with _$ChallengesState {
  const factory ChallengesState.loading() = ChallengesLoading;
  const factory ChallengesState.data({required int record}) = ChallengesData;
  const factory ChallengesState.error({required String message}) = ChallengesError;
}
