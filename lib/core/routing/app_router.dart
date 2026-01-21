import 'package:go_router/go_router.dart';
import 'package:ball_game/core/routing/app_routes.dart';
import 'package:ball_game/core_ui/preview/design_system_preview_page.dart';
import 'package:ball_game/presentation/challenges/page/challenges_page.dart';
import 'package:ball_game/presentation/play/page/play_page.dart';
import 'package:ball_game/presentation/settings/page/settings_page.dart';
import 'package:ball_game/presentation/shell/page/app_shell_page.dart';
import 'package:ball_game/presentation/skins/page/skins_page.dart';
import 'package:ball_game/presentation/stats/page/stats_page.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.play,
  routes: [
    GoRoute(
      path: AppRoutes.root,
      redirect: (context, state) => AppRoutes.play,
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShellPage(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.play,
              builder: (context, state) => const PlayPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.challenges,
              builder: (context, state) => const ChallengesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.skins,
              builder: (context, state) => const SkinsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.stats,
              builder: (context, state) => const StatsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.designSystem,
      builder: (context, state) => const DesignSystemPreviewPage(),
    ),
  ],
);
