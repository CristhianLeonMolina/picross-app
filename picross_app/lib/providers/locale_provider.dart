import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('es');

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    if (!L10n.all.contains(newLocale)) return;
    _locale = newLocale;
    notifyListeners();
  }
}

/// Opcional: clase de idiomas disponibles
class L10n {
  static final all = [
    const Locale('en'),
    const Locale('es'),
  ];
}