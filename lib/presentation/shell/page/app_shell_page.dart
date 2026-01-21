import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ball_game/core/di/get_it.dart';
import 'package:ball_game/presentation/skins/bloc/skins_cubit.dart';

class AppShellPage extends StatelessWidget {
  const AppShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return BlocProvider(
      create: (_) => getIt<SkinsCubit>(),
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == currentIndex,
            );
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.play_circle_outline),
              label: 'Play',
            ),
            NavigationDestination(
              icon: Icon(Icons.flag_outlined),
              label: 'Challenges',
            ),
            NavigationDestination(
              icon: Icon(Icons.palette_outlined),
              label: 'Skins',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              label: 'Stats',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
