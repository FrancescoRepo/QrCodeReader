import 'package:qrcodereader/models/ContactInfo.dart';
import 'package:qrcodereader/models/GeoInfo.dart';
import 'package:qrcodereader/models/PlainTextInfo.dart';
import 'package:qrcodereader/models/UrlInfo.dart';
import 'package:qrcodereader/models/WifiInfo.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qrcodereader/utils/constants.dart';

part 'Info.g.dart';

@JsonSerializable()
class Info {
  String id;
  String title;
  DateTime date;

  Info(this.id, this.title, this.date);

  static Future<List<Info>> fromInfoJson(List<dynamic> json) async {
    List<Info> infoList = new List<Info>();
    for (var info in json) {
      switch (info['title']) {
        case InfoContentNames.WIFI_CONTENT:
          infoList.add(new WifiInfo(
              info['id'], info['type'], info['ssid'], info['password']));
          break;
        case InfoContentNames.URL_CONTENT:
          infoList.add(new UrlInfo(info['id'], info['titleUrl']));
          break;
        case InfoContentNames.GPS_CONTENT:
          infoList.add(
              new GeoInfo(info['id'], info['latitude'], info['longitude']));
          break;
        case InfoContentNames.TEXT_CONTENT:
          infoList.add(new PlainTextInfo(info['id'], info['text']));
          break;
        case InfoContentNames.CARD_CONTENT:
          infoList.add(new ContactInfo(
              info['id'],
              info['fullname'],
              info['name'],
              info['org'],
              info['titleContact'],
              info['phoneNumbers'],
              info['address'],
              info['emails'],
              info['url']));
          break;
      }
    }
    return infoList;
  }

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);

  Map<String, dynamic> toJson() => _$InfoToJson(this);
}
