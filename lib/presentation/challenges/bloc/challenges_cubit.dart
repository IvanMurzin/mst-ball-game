import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ball_game/core/local_storage/game_scores_storage.dart';

part 'challenges_cubit.freezed.dart';
part 'challenges_state.dart';

@injectable
class ChallengesCubit extends Cubit<ChallengesState> {
  ChallengesCubit(this._storage) : super(const ChallengesState.loading()) {
    _scoresSubscription = _storage.watchScores().listen(
      _onScoresUpdated,
      onError: (_) => emit(const ChallengesState.error(message: 'Failed to load challenges')),
    );
  }

  final GameScoresStorage _storage;
  StreamSubscription<List<int>>? _scoresSubscription;

  void _onScoresUpdated(List<int> scores) {
    final record = scores.isEmpty ? 0 : scores.reduce(max);
    emit(ChallengesState.data(record: record));
  }

  @override
  Future<void> close() {
    _scoresSubscription?.cancel();
    return super.close();
  }
}
