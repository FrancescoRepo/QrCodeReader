import 'package:qrcodereader/utils/constants.dart';

class EventObject {
  int id;
  Object object;

  EventObject({this.id: Events.NO_INTERNET_CONNECTION, this.object});
}
