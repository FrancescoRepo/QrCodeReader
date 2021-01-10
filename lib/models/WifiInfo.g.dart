// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WifiInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WifiInfo _$WifiInfoFromJson(Map<String, dynamic> json) {
  return WifiInfo(
    json['id'] as String,
    json['type'] as String,
    json['ssid'] as String,
    json['password'] as String,
  )
    ..title = json['title'] as String
    ..date =
        json['date'] == null ? null : DateTime.parse(json['date'] as String);
}

Map<String, dynamic> _$WifiInfoToJson(WifiInfo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date?.toIso8601String(),
      'type': instance.type,
      'ssid': instance.ssid,
      'password': instance.password,
    };
