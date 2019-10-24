import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _storageKey = 'Upcentral_';
const List<String> _supportedLanguages = <String>['en'];
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class LanguageController {
  Locale _locale;
  Map<dynamic, dynamic> _localizedValues;
  VoidCallback _onLocaleChangedCallback;

  Iterable<Locale> supportedLocales() =>
      _supportedLanguages.map<Locale>((String lang) => Locale(lang, ''));

  List<String> supportedLanguages() => _supportedLanguages;

  String text(String key) {
    // Return the requested string
    return (_localizedValues == null || _localizedValues[key] == null)
        ? '** $key not found'
        : _localizedValues[key];
  }

  String get currentLanguage => _locale == null ? '' : _locale.languageCode;

  Locale get locale => _locale;

  Future<void> init([String language]) async {
    if (_locale == null) {
      await setNewLanguage(language);
    }
    return;
  }

  Future<String> getPreferredLanguage() async {
    return _getApplicationSavedInformation('language');
  }

  Future<bool> setPreferredLanguage(String lang) async {
    return _setApplicationSavedInformation('language', lang);
  }

  Future<void> setNewLanguage(
      [String newLanguage, bool saveInPrefs = false]) async {
    String language = newLanguage;
    language ??= await getPreferredLanguage();

    // Set the locale
    if (language == '') {
      language = 'en';
    }
    _locale = Locale(language, '');

    // Load the language strings
    final String jsonContent = await rootBundle
        .loadString('assets/locale/i18n_${_locale.languageCode}.json');
    _localizedValues = json.decode(jsonContent);

    // If we are asked to save the new language in the application preferences
    if (saveInPrefs) {
      await setPreferredLanguage(language);
    }

    // If there is a callback to invoke to notify that a language has changed
    if (_onLocaleChangedCallback != null) {
      _onLocaleChangedCallback();
    }

    return;
  }

  set onLocaleChangedCallback(VoidCallback callback) {
    _onLocaleChangedCallback = callback;
  }

  Future<String> _getApplicationSavedInformation(String name) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKey + name) ?? '';
  }

  Future<bool> _setApplicationSavedInformation(
      String name, String value) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKey + name, value);
  }

  static final LanguageController _translations = LanguageController._internal();
  factory LanguageController() {
    return _translations;
  }
  LanguageController._internal();
}

LanguageController allTranslations = LanguageController();
