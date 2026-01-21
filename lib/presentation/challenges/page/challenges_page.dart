import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ball_game/core/di/get_it.dart';
import 'package:ball_game/core_ui/components/card/ds_card.dart';
import 'package:ball_game/core_ui/components/typography/ds_section_title.dart';
import 'package:ball_game/core_ui/tokens/ds_spacing.dart';
import 'package:ball_game/presentation/challenges/bloc/challenges_cubit.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChallengesCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Challenges')),
        body: SafeArea(
          child: BlocBuilder<ChallengesCubit, ChallengesState>(
            builder: (context, state) {
              return ListView(
                padding: DSSpacing.page,
                children: [
                  const SizedBox(height: DSSpacing.s12),
                  ...state.when(
                    loading: () => [const Center(child: CircularProgressIndicator())],
                    error: (message) => [DSCard(child: Text(message))],
                    data: (record) {
                      const targets = [20, 50, 100];
                      return [
                        Theme(
                          data: Theme.of(context).copyWith(
                            cardTheme: CardThemeData(
                              color: Theme.of(context).colorScheme.primaryContainer,
                            ),
                          ),
                          child: DSCard(
                            header: const DSSectionTitle('Record'),
                            child: Text(record.toString()),
                          ),
                        ),
                        const SizedBox(height: DSSpacing.s12),
                        DSCard(
                          header: const DSSectionTitle('Goals'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final target in targets) ...[
                                Row(
                                  children: [
                                    Icon(
                                      record >= target
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: record >= target
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.outline,
                                    ),
                                    const SizedBox(width: DSSpacing.s12),
                                    Expanded(
                                      child: Text(
                                        'Reach $target points',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              decoration: record >= target
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      record >= target ? 'Completed' : '$record/$target',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                if (target != targets.last)
                                  const SizedBox(height: DSSpacing.s12),
                              ],
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
