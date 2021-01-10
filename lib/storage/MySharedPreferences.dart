import 'dart:convert';

import 'package:qrcodereader/models/EventObject.dart';
import 'package:qrcodereader/models/Info.dart';
import 'package:qrcodereader/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static Future<SharedPreferences> getInstance() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance;
  }

  static Future<EventObject> getInfosPrefs() async {
    var prefs = await getInstance();
    if (prefs.getString(SharedPreferencesKeys.INFOS) == null)
      return new EventObject(id: Events.NO_INFOS_FOUND);
    else {
      List<Info> infos = await Info.fromInfoJson(
          json.decode(prefs.getString(SharedPreferencesKeys.INFOS)));
      if (infos.isNotEmpty)
        return new EventObject(
            id: Events.READ_INFOS_SUCCESSFULLY, object: infos);

      return new EventObject(id: Events.NO_INFOS_FOUND);
    }
  }

  static Future<EventObject> saveInfoPrefs(Info info) async {
    var prefs = await getInstance();
    EventObject eventObject = await getInfosPrefs();
    List<Info> infos;
    if (eventObject.id == Events.NO_INFOS_FOUND)
      infos = new List<Info>();
    else
      infos = eventObject.object;

    infos.add(info);
    bool success =
        await prefs.setString(SharedPreferencesKeys.INFOS, json.encode(infos));

    if (success != null)
      return new EventObject(id: Events.INFO_CREATED_SUCCESSFULLY);

    return new EventObject(id: Events.UNABLE_TO_CREATE_INFO);
  }

  static Future<EventObject> deleteInfoPrefs(String idInfoToDelete) async {
    var prefs = await getInstance();
    EventObject eventObject = await getInfosPrefs();
    List<Info> infos;

    if (eventObject.id == Events.NO_INFOS_FOUND)
      return new EventObject(id: Events.NO_INFOS_FOUND);
    else if (eventObject.id == Events.READ_INFOS_SUCCESSFULLY)
      infos = eventObject.object;

    for (int i = 0; i < infos.length; i++) {
      if (infos[i].id == idInfoToDelete) {
        infos.removeAt(i);
        break;
      }
    }

    bool success =
        await prefs.setString(SharedPreferencesKeys.INFOS, json.encode(infos));
    if (success != null)
      return new EventObject(id: Events.INFOS_DELETED_SUCCESSFULLY);

    return new EventObject(id: Events.UNABLE_TO_DELETED_INFOS);
  }
}
