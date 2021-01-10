import 'package:json_annotation/json_annotation.dart';
import 'package:qrcodereader/models/Info.dart';

part 'WifiInfo.g.dart';

@JsonSerializable()
class WifiInfo extends Info {
  String type;
  String ssid;
  String password;

  WifiInfo(String id, this.type, this.ssid, this.password)
      : super(id, 'Wifi Content', DateTime.now());

  factory WifiInfo.fromJson(Map<String, dynamic> json) =>
      _$WifiInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WifiInfoToJson(this);
}
