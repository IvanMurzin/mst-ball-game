import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ball_game/core/di/get_it.dart';
import 'package:ball_game/core_ui/tokens/ds_spacing.dart';
import 'package:ball_game/presentation/play/bloc/game_cubit.dart';
import 'package:ball_game/presentation/play/widget/game_field.dart';
import 'package:ball_game/presentation/play/widget/game_hud.dart';
import 'package:ball_game/presentation/play/widget/game_over_panel.dart';

class PlayPage extends StatelessWidget {
  const PlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GameCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Play')),
        body: SafeArea(
          child: Padding(
            padding: DSSpacing.page,
            child: Stack(
              children: [
                const Positioned.fill(child: GameField()),
                BlocBuilder<GameCubit, GameState>(
                  builder: (context, state) {
                    if (state is GameRunning) {
                      return const Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: DSSpacing.s8),
                          child: GameHud(),
                        ),
                      );
                    }
                    if (state is GameIdle || state is GameError) {
                      return const Center(child: GameHud());
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const GameOverPanel(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
