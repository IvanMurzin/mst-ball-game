import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ball_game/core_ui/components/button/ds_button.dart';
import 'package:ball_game/core_ui/components/card/ds_card.dart';
import 'package:ball_game/core_ui/tokens/ds_spacing.dart';
import 'package:ball_game/presentation/play/bloc/game_cubit.dart';

class GameHud extends StatelessWidget {
  const GameHud({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        final isIdle = state is GameIdle || state is GameError;
        final score = state.maybeWhen(
          running: (
            ballY,
            ballVelocityY,
            grounded,
            platforms,
            score,
            elapsed,
          ) =>
              score,
          orElse: () => 0.0,
        );

        return DSCard(
          child: isIdle
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HudValue(
                      label: 'Tap to jump',
                      value: 'Land on platforms',
                    ),
                    const SizedBox(height: DSSpacing.s12),
                    DSButton(
                      label: 'Start',
                      onPressed: () => context.read<GameCubit>().start(),
                    ),
                  ],
                )
              : _HudValue(
                  label: 'Score',
                  value: score.floor().toString(),
                ),
        );
      },
    );
  }
}

class _HudValue extends StatelessWidget {
  const _HudValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelMedium),
        Text(value, style: textTheme.titleMedium),
      ],
    );
  }
}
