// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UrlInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UrlInfo _$UrlInfoFromJson(Map<String, dynamic> json) {
  return UrlInfo(
    json['id'] as String,
    json['titleUrl'] as String,
  )
    ..title = json['title'] as String
    ..date =
        json['date'] == null ? null : DateTime.parse(json['date'] as String);
}

Map<String, dynamic> _$UrlInfoToJson(UrlInfo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date?.toIso8601String(),
      'titleUrl': instance.titleUrl,
    };
