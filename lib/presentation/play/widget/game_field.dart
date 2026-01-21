import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ball_game/core/types/ball_skin.dart';
import 'package:ball_game/domain/ball_runner/entity/platform_entity.dart';
import 'package:ball_game/presentation/play/bloc/game_cubit.dart';
import 'package:ball_game/presentation/skins/bloc/skins_cubit.dart';

class GameField extends StatefulWidget {
  const GameField({super.key});

  @override
  State<GameField> createState() => _GameFieldState();
}

class _GameFieldState extends State<GameField> {
  Size _lastSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (size != _lastSize && size.isFinite) {
          _lastSize = size;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<GameCubit>().setFieldSize(size);
          });
        }

        return BlocBuilder<GameCubit, GameState>(
          builder: (context, state) {
            final skinState = context.watch<SkinsCubit>().state;
            final selectedSkin = skinState.maybeWhen(
              ready: (selected) => selected,
              orElse: () => BallSkin.blue,
            );
            final data = state.maybeWhen(
              running:
                  (ballY, ballVelocityY, grounded, platforms, score, elapsed) =>
                      (ballY, platforms),
              orElse: () => (null, <PlatformEntity>[]),
            );
            final ballY = data.$1;
            final platforms = data.$2;
            final scheme = Theme.of(context).colorScheme;
            final ballColor = _skinToColor(selectedSkin);

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.read<GameCubit>().onTapJump(),
              child: CustomPaint(
                painter: GameFieldPainter(
                  ballY: ballY,
                  platforms: platforms,
                  backgroundColor: scheme.surfaceContainerHighest,
                  platformColor: scheme.primary,
                  ballColor: ballColor,
                ),
                size: Size.infinite,
              ),
            );
          },
        );
      },
    );
  }

  Color _skinToColor(BallSkin skin) {
    return switch (skin) {
      BallSkin.blue => Colors.blue,
      BallSkin.red => Colors.red,
      BallSkin.green => Colors.green,
    };
  }
}

class GameFieldPainter extends CustomPainter {
  GameFieldPainter({
    required this.ballY,
    required this.platforms,
    required this.backgroundColor,
    required this.platformColor,
    required this.ballColor,
  });

  final double? ballY;
  final List<PlatformEntity> platforms;
  final Color backgroundColor;
  final Color platformColor;
  final Color ballColor;

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final platformPaint = Paint()..color = platformColor;
    for (final platform in platforms) {
      final rect = Rect.fromLTWH(
        platform.x,
        platform.y,
        platform.width,
        platform.height,
      );
      canvas.drawRect(rect, platformPaint);
    }

    if (ballY != null) {
      final radius = ((size.width + size.height) * 0.015).clamp(10.0, 18.0);
      final ballX = size.width * 0.2;
      final ballPaint = Paint()..color = ballColor;
      canvas.drawCircle(Offset(ballX, ballY!), radius, ballPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GameFieldPainter oldDelegate) {
    return oldDelegate.ballY != ballY ||
        oldDelegate.platforms != platforms ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.platformColor != platformColor ||
        oldDelegate.ballColor != ballColor;
  }
}
