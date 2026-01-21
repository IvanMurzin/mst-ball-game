import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ball_game/core/types/ball_skin.dart';
import 'package:ball_game/core_ui/components/card/ds_card.dart';
import 'package:ball_game/core_ui/components/typography/ds_section_title.dart';
import 'package:ball_game/core_ui/tokens/ds_spacing.dart';
import 'package:ball_game/presentation/skins/bloc/skins_cubit.dart';
import 'package:ball_game/presentation/skins/widget/skin_card.dart';

class SkinsPage extends StatelessWidget {
  const SkinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skins')),
      body: SafeArea(
        child: ListView(
          padding: DSSpacing.page,
          children: [
            const DSSectionTitle('Skins'),
            const SizedBox(height: DSSpacing.s12),
            BlocBuilder<SkinsCubit, SkinsState>(
              builder: (context, state) {
                return state.when(
                  loading: () => const DSCard(child: Text('Loading skins...')),
                  error: (message) => DSCard(child: Text(message)),
                  ready: (selected) => Column(
                    children: [
                      SkinCard(
                        title: 'Blue',
                        color: Colors.blue,
                        selected: selected == BallSkin.blue,
                        onTap: () => context.read<SkinsCubit>().select(BallSkin.blue),
                      ),
                      const SizedBox(height: DSSpacing.s12),
                      SkinCard(
                        title: 'Red',
                        color: Colors.red,
                        selected: selected == BallSkin.red,
                        onTap: () => context.read<SkinsCubit>().select(BallSkin.red),
                      ),
                      const SizedBox(height: DSSpacing.s12),
                      SkinCard(
                        title: 'Green',
                        color: Colors.green,
                        selected: selected == BallSkin.green,
                        onTap: () => context.read<SkinsCubit>().select(BallSkin.green),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
