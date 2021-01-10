// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GeoInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoInfo _$GeoInfoFromJson(Map<String, dynamic> json) {
  return GeoInfo(
    json['id'] as String,
    (json['latitude'] as num)?.toDouble(),
    (json['longitude'] as num)?.toDouble(),
  )
    ..title = json['title'] as String
    ..date =
        json['date'] == null ? null : DateTime.parse(json['date'] as String);
}

Map<String, dynamic> _$GeoInfoToJson(GeoInfo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date?.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
