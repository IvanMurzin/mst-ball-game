import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ball_game/core/di/get_it.dart';
import 'package:ball_game/core_ui/components/button/ds_button.dart';
import 'package:ball_game/core_ui/components/card/ds_card.dart';
import 'package:ball_game/core_ui/components/typography/ds_section_title.dart';
import 'package:ball_game/core_ui/theme/theme_mode_cubit.dart';
import 'package:ball_game/core_ui/tokens/ds_spacing.dart';
import 'package:ball_game/presentation/settings/bloc/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: SafeArea(
          child: ListView(
            padding: DSSpacing.page,
            children: [
              const DSSectionTitle('Preferences'),
              const SizedBox(height: DSSpacing.s12),
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  return DSCard(
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Sound'),
                          value: state.soundEnabled,
                          onChanged: context.read<SettingsCubit>().toggleSound,
                        ),
                        SwitchListTile(
                          title: const Text('Vibration'),
                          value: state.vibrationEnabled,
                          onChanged: context.read<SettingsCubit>().toggleVibration,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: DSSpacing.s24),
              const DSSectionTitle('Theme'),
              const SizedBox(height: DSSpacing.s12),
              BlocBuilder<ThemeModeCubit, ThemeMode>(
                builder: (context, mode) {
                  return DSCard(
                    child: Wrap(
                      spacing: DSSpacing.s8,
                      runSpacing: DSSpacing.s8,
                      children: [
                        DSButton(
                          label: 'System',
                          variant: mode == ThemeMode.system
                              ? DSButtonVariant.primary
                              : DSButtonVariant.secondary,
                          onPressed: () => context.read<ThemeModeCubit>().set(ThemeMode.system),
                        ),
                        DSButton(
                          label: 'Light',
                          variant: mode == ThemeMode.light
                              ? DSButtonVariant.primary
                              : DSButtonVariant.secondary,
                          onPressed: () => context.read<ThemeModeCubit>().set(ThemeMode.light),
                        ),
                        DSButton(
                          label: 'Dark',
                          variant: mode == ThemeMode.dark
                              ? DSButtonVariant.primary
                              : DSButtonVariant.secondary,
                          onPressed: () => context.read<ThemeModeCubit>().set(ThemeMode.dark),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: DSSpacing.s24),
              const DSSectionTitle('About'),
              const SizedBox(height: DSSpacing.s12),
              const DSCard(child: Text('Ball Runner MVP with basic jump and platforms.')),
            ],
          ),
        ),
      ),
    );
  }
}
