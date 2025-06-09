import 'package:picross_app/l10n/app_localizations.dart';
import 'package:picross_app/screens/home_screen.dart';

import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final whiteHeadline = Theme.of(context).textTheme.headlineMedium?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    final whiteBody = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(color: Colors.white);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(30, 60, 120, 0.9),
            Color.fromRGBO(50, 90, 160, 0.9),
            Color.fromRGBO(85, 20, 140, 0.9),
            Color.fromRGBO(120, 40, 180, 0.9),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            loc.instructions_title,
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.whats_nonogram_title,
                style: whiteHeadline,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              Text(
                loc.whats_nonogram_body,
                style: whiteBody,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              Text(
                loc.how_to_play_title,
                style: whiteHeadline,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              Text(
                loc.how_to_play_body,
                style: whiteBody,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              Text(
                loc.basic_rules_title,
                style: whiteHeadline,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              Text(
                loc.basic_rules_body,
                style: whiteBody,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              Text(
                loc.advices_title,
                style: whiteHeadline,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              Text(
                loc.advices_body,
                style: whiteBody,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}