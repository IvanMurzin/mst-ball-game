import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ball_game/core/local_storage/ball_skin_storage.dart';
import 'package:ball_game/core/types/ball_skin.dart';

part 'skins_cubit.freezed.dart';
part 'skins_state.dart';

@injectable
class SkinsCubit extends Cubit<SkinsState> {
  SkinsCubit(this._storage) : super(const SkinsState.loading()) {
    _load();
  }

  final BallSkinStorage _storage;

  Future<void> _load() async {
    try {
      final stored = await _storage.readBallSkin();
      emit(SkinsState.ready(selected: stored ?? BallSkin.blue));
    } catch (_) {
      emit(const SkinsState.error(message: 'Failed to load skins'));
    }
  }

  void select(BallSkin skin) {
    emit(SkinsState.ready(selected: skin));
    _storage.writeBallSkin(skin);
  }
}
