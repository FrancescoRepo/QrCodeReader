import 'package:json_annotation/json_annotation.dart';
import 'package:qrcodereader/models/Info.dart';

part 'UrlInfo.g.dart';

@JsonSerializable()
class UrlInfo extends Info {
  String titleUrl;

  UrlInfo(String id, this.titleUrl) : super(id, 'URL Content', DateTime.now());

  factory UrlInfo.fromJson(Map<String, dynamic> json) =>
      _$UrlInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UrlInfoToJson(this);
}
