// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContactInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) {
  return ContactInfo(
    json['id'] as String,
    json['fullname'] as String,
    json['name'] as String,
    json['org'] as String,
    json['titleContact'] as String,
    json['phoneNumbers'] as List,
    json['address'] as String,
    json['emails'] as List,
    json['url'] as String,
  )
    ..title = json['title'] as String
    ..date =
        json['date'] == null ? null : DateTime.parse(json['date'] as String);
}

Map<String, dynamic> _$ContactInfoToJson(ContactInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date?.toIso8601String(),
      'fullname': instance.fullname,
      'name': instance.name,
      'org': instance.org,
      'titleContact': instance.titleContact,
      'phoneNumbers': instance.phoneNumbers,
      'address': instance.address,
      'emails': instance.emails,
      'url': instance.url,
    };
