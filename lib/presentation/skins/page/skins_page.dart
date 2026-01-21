import 'package:flutter/material.dart';
import 'package:ball_game/core_ui/components/card/ds_card.dart';
import 'package:ball_game/core_ui/components/typography/ds_section_title.dart';
import 'package:ball_game/core_ui/tokens/ds_spacing.dart';

class SkinsPage extends StatelessWidget {
  const SkinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skins')),
      body: SafeArea(
        child: ListView(
          padding: DSSpacing.page,
          children: const [
            DSSectionTitle('Skins'),
            SizedBox(height: DSSpacing.s12),
            DSCard(
              child: Text('Unlockable skins will be shown here.'),
            ),
          ],
        ),
      ),
    );
  }
}
