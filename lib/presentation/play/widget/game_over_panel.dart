import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ball_game/core_ui/components/button/ds_button.dart';
import 'package:ball_game/core_ui/components/card/ds_card.dart';
import 'package:ball_game/core_ui/components/typography/ds_section_title.dart';
import 'package:ball_game/core_ui/tokens/ds_spacing.dart';
import 'package:ball_game/presentation/play/bloc/game_cubit.dart';

class GameOverPanel extends StatelessWidget {
  const GameOverPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        if (state is! GameGameOver) {
          return const SizedBox.shrink();
        }

        return Center(
          child: Padding(
            padding: DSSpacing.page,
            child: DSCard(
              padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 16),
              child: Column(
                children: [
                  const DSSectionTitle('Game Over'),
                  const SizedBox(height: DSSpacing.s12),
                  Text('Score: ${state.finalScore.floor()}'),
                  const SizedBox(height: DSSpacing.s16),
                  DSButton(label: 'Retry', onPressed: () => context.read<GameCubit>().retry()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
