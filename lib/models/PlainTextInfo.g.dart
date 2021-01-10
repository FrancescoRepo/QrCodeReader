// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PlainTextInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlainTextInfo _$PlainTextInfoFromJson(Map<String, dynamic> json) {
  return PlainTextInfo(
    json['id'] as String,
    json['text'] as String,
  )
    ..title = json['title'] as String
    ..date =
        json['date'] == null ? null : DateTime.parse(json['date'] as String);
}

Map<String, dynamic> _$PlainTextInfoToJson(PlainTextInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date?.toIso8601String(),
      'text': instance.text,
    };
