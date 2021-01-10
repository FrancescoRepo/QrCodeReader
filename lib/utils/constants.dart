class Constants {}

class Events {
  static const int READ_INFOS_SUCCESSFULLY = 500;
  static const int NO_INFOS_FOUND = 501;
  static const int INFO_CREATED_SUCCESSFULLY = 502;
  static const int UNABLE_TO_CREATE_INFO = 503;
  static const int INFOS_DELETED_SUCCESSFULLY = 504;
  static const int UNABLE_TO_DELETED_INFOS = 505;

  static const int NO_INTERNET_CONNECTION = 506;
}

class SharedPreferencesKeys {
  static const String INFOS = "INFOS";
}

class InfoContentNames {
  static const String WIFI_CONTENT = "Wifi Content";
  static const String URL_CONTENT = "URL Content";
  static const String CARD_CONTENT = "Contact Content";
  static const String GPS_CONTENT = "Geo Content";
  static const String TEXT_CONTENT = "Plain Text Content";
}
