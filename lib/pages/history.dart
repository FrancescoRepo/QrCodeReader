import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrcodereader/localization/AppLocalizations.dart';
import 'package:qrcodereader/models/EventObject.dart';
import 'package:qrcodereader/models/Info.dart';
import 'package:qrcodereader/pages/detail.dart';
import 'package:qrcodereader/storage/MySharedPreferences.dart';
import 'package:qrcodereader/utils/constants.dart';

class History extends StatefulWidget {
  HistoryState createState() => HistoryState();
}

class HistoryState extends State<History> {
  List<Info> qrScans = new List<Info>();
  EventObject eventObject;
  Map<String, bool> mapScans = new Map<String, bool>();

  @override
  void initState() {
    loadInfos();
    super.initState();
  }

  void loadInfos() {
    MySharedPreferences.getInfosPrefs().then((value) {
      if (value.id == Events.READ_INFOS_SUCCESSFULLY)
        setState(() {
          qrScans = value.object;
        });
      else
        setState(() {
          qrScans = new List<Info>();
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).historyQR),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                tooltip: AppLocalizations.of(context).deleteSelected,
                onPressed: () => deleteSelected(context),
              );
            },
          )
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scaffold(
      body: ListView(
          padding: EdgeInsets.all(8.0),
          children: qrScans.map((info) => buildListItem(info)).toList()),
    );
  }

  Widget buildListItem(Info info) {
    var myFormat = DateFormat('d-MM-yyyy hh:mm');
    return Card(
      child: Column(
        children: <Widget>[
          CheckboxListTile(
            title: Text(info.title),
            value: mapScans[info.id] ?? false,
            subtitle: Text(
                AppLocalizations.of(context).date + myFormat.format(info.date)),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (val) {
              setState(() {
                mapScans[info.id] = val;
              });
            },
            secondary: Container(
              child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detail(
                                      info: info,
                                    )))
                      }),
            ),
          ),
        ],
      ),
    );
  }

  void deleteSelected(BuildContext appBarContext) async {
    if (mapScans.length > 0) {
      for (int i = 0; i < mapScans.length; i++) {
        if (mapScans.values.elementAt(i) == true) {
          await MySharedPreferences.deleteInfoPrefs(mapScans.keys.elementAt(i));
        }
      }
      loadInfos(); //Reload infos
    } else if (!mapScans.values.any((val) => val == true)) {
      Scaffold.of(appBarContext).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).selectOneItem),
      ));
    }
  }
}
