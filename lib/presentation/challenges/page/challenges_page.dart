import 'package:flutter/material.dart';
import 'package:ball_game/core_ui/components/card/ds_card.dart';
import 'package:ball_game/core_ui/components/typography/ds_section_title.dart';
import 'package:ball_game/core_ui/tokens/ds_spacing.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Challenges')),
      body: SafeArea(
        child: ListView(
          padding: DSSpacing.page,
          children: const [
            DSSectionTitle('Upcoming challenges'),
            SizedBox(height: DSSpacing.s12),
            DSCard(child: Text('New challenge modes will appear here.')),
          ],
        ),
      ),
    );
  }
}
