import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations{
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    print("languageFile_${locale.languageCode}");
    String jsonString = await rootBundle.loadString('assets/locale/floodup_${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key];
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
//    print("languageCode=${locale.languageCode}");
    return ['en', 'fr', 'es', 'ca'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = new AppLocalizations(locale);
    print("languageCode=${locale.languageCode}   ${locale.countryCode}");
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}