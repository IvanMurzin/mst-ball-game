import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

@lazySingleton
class GameScoresStorage {
  static const _key = 'game_scores';
  final StreamController<List<int>> _controller = StreamController<List<int>>.broadcast();

  Future<List<int>> readScores() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(_key) ?? [];
    return _parse(values);
  }

  Stream<List<int>> watchScores() async* {
    yield await readScores();
    yield* _controller.stream;
  }

  Future<void> appendScore(int score, {int limit = 50}) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];
    final updated = <String>[score.toString(), ...current];
    if (updated.length > limit) {
      updated.removeRange(limit, updated.length);
    }
    await prefs.setStringList(_key, updated);
    _controller.add(_parse(updated));
  }

  List<int> _parse(List<String> values) {
    return values.map((value) => int.tryParse(value)).whereType<int>().toList();
  }
}
