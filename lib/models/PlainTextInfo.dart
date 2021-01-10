import 'package:json_annotation/json_annotation.dart';
import 'package:qrcodereader/models/Info.dart';

part 'PlainTextInfo.g.dart';

@JsonSerializable()
class PlainTextInfo extends Info {
  String text;

  PlainTextInfo(String id, this.text)
      : super(id, 'Plain Text Content', DateTime.now());

  factory PlainTextInfo.fromJson(Map<String, dynamic> json) =>
      _$PlainTextInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PlainTextInfoToJson(this);
}
