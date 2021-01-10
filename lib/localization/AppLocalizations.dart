import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrcodereader/messages/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get history {
    return Intl.message('History', name: 'history');
  }

  String get clearAll {
    return Intl.message('Clear All', name: 'clearAll');
  }

  String get date {
    return Intl.message('Date', name: 'date');
  }

  String get share {
    return Intl.message('Share', name: 'share');
  }

  String get copy {
    return Intl.message('Copy', name: 'copy');
  }

  String get addContact {
    return Intl.message('Add Contact', name: 'addContact');
  }

  String get urlNotValid {
    return Intl.message('Url Not Valid', name: 'urlNotValid');
  }

  String get textCopied {
    return Intl.message('Text Copied', name: 'textCopied');
  }

  String get linkCopied {
    return Intl.message('Link Copied', name: 'linkCopied');
  }

  String get deleteSelected {
    return Intl.message('Delete Selected', name: 'deleteSelected');
  }

  String get historyQR {
    return Intl.message('History QR', name: 'historyQR');
  }

  String get selectOneItem {
    return Intl.message('Select at least 1 item', name: 'selectOneItem');
  }

  String get goToMaps {
    return Intl.message('Go To Maps', name: 'goToMaps');
  }

  String get search {
    return Intl.message('Search', name: 'search');
  }

  String get cameraDenied {
    return Intl.message('Camera Permission Denied', name: 'cameraDenied');
  }

  String get openSettings {
    return Intl.message('Open Settings', name: 'openSettings');
  }

  String get wifiContent {
    return Intl.message('Wifi Content', name: 'wifiContent');
  }

  String get geoContent {
    return Intl.message('Geo Content', name: 'geoContent');
  }

  String get contactContent {
    return Intl.message('Contact Content', name: 'contactContent');
  }

  String get plainTextContent {
    return Intl.message('Plain Text Content', name: 'plainTextContent');
  }

  String get urlContent {
    return Intl.message('URL Content', name: 'urlContent');
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['it', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
