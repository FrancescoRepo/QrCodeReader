import 'package:json_annotation/json_annotation.dart';
import 'package:qrcodereader/models/Info.dart';

part 'GeoInfo.g.dart';

@JsonSerializable()
class GeoInfo extends Info {
  double latitude;
  double longitude;

  GeoInfo(String id, this.latitude, this.longitude)
      : super(id, 'Geo Content', DateTime.now());

  factory GeoInfo.fromJson(Map<String, dynamic> json) =>
      _$GeoInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GeoInfoToJson(this);
}
