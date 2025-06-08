import 'package:flutter/material.dart';
import 'package:picross_app/l10n/app_localizations.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.credits_title),
      ),
      body: Center(
        child: Text(loc.credits_body),
      ),
    );
  }
}
