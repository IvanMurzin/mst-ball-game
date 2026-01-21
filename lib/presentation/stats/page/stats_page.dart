import 'package:ball_game/core/di/get_it.dart';
import 'package:ball_game/core_ui/components/card/ds_card.dart';
import 'package:ball_game/core_ui/components/typography/ds_section_title.dart';
import 'package:ball_game/core_ui/tokens/ds_spacing.dart';
import 'package:ball_game/presentation/stats/bloc/stats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StatsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Stats')),
        body: SafeArea(
          child: BlocBuilder<StatsCubit, StatsState>(
            builder: (context, state) {
              return ListView(
                padding: DSSpacing.page,
                children: [
                  const SizedBox(height: DSSpacing.s12),
                  ...state.when(
                    loading: () => [const Center(child: CircularProgressIndicator())],
                    empty: () => const [DSCard(child: Text('No results yet.'))],
                    error: (message) => [DSCard(child: Text(message))],
                    data: (scores, record) => [
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
                      const DSSectionTitle('Results'),
                      const SizedBox(height: DSSpacing.s8),
                      for (final entry in scores.asMap().entries) ...[
                        DSCard(child: Text('${entry.value}')),
                        if (entry.key != scores.length - 1) const SizedBox(height: DSSpacing.s8),
                      ],
                    ],
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
