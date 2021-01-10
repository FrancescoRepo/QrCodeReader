import 'package:json_annotation/json_annotation.dart';
import 'package:qrcodereader/models/Info.dart';

part 'ContactInfo.g.dart';

@JsonSerializable()
class ContactInfo extends Info {
  String fullname;
  String name;
  String org;
  String titleContact;
  List<dynamic> phoneNumbers;
  String address;
  List<dynamic> emails;
  String url;

  ContactInfo(String id, this.fullname, this.name, this.org, this.titleContact,
      this.phoneNumbers, this.address, this.emails, this.url)
      : super(id, "Contact Content", DateTime.now());

  factory ContactInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ContactInfoToJson(this);
}
