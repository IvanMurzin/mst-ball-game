import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ball_game/core/local_storage/game_scores_storage.dart';

part 'stats_cubit.freezed.dart';
part 'stats_state.dart';

@injectable
class StatsCubit extends Cubit<StatsState> {
  StatsCubit(this._storage) : super(const StatsState.loading()) {
    _subscription = _storage.watchScores().listen(
      _onScores,
      onError: (_) => emit(const StatsState.error(message: 'Failed to load stats')),
    );
  }

  final GameScoresStorage _storage;
  late final StreamSubscription<List<int>> _subscription;

  void _onScores(List<int> scores) {
    if (scores.isEmpty) {
      emit(const StatsState.empty());
      return;
    }
    final record = scores.reduce(max);
    emit(StatsState.data(scores: scores, record: record));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
