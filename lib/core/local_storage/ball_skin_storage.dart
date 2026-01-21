import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ball_game/core/types/ball_skin.dart';

@lazySingleton
class BallSkinStorage {
  static const _key = 'ball_skin';

  Future<BallSkin?> readBallSkin() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    return _parse(value);
  }

  Future<void> writeBallSkin(BallSkin skin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _serialize(skin));
  }

  String _serialize(BallSkin skin) {
    return switch (skin) {
      BallSkin.blue => 'blue',
      BallSkin.red => 'red',
      BallSkin.green => 'green',
    };
  }

  BallSkin? _parse(String? value) {
    return switch (value) {
      'blue' => BallSkin.blue,
      'red' => BallSkin.red,
      'green' => BallSkin.green,
      _ => null,
    };
  }
}
