import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrcodereader/localization/AppLocalizations.dart';
import 'package:qrcodereader/models/ContactInfo.dart';
import 'package:qrcodereader/models/EventObject.dart';
import 'package:qrcodereader/models/GeoInfo.dart';
import 'package:qrcodereader/models/Info.dart';
import 'package:qrcodereader/models/PlainTextInfo.dart';
import 'package:qrcodereader/models/UrlInfo.dart';
import 'package:qrcodereader/models/WifiInfo.dart';
import 'package:qrcodereader/pages/detail.dart';
import 'package:qrcodereader/pages/history.dart';
import 'package:qrcodereader/storage/MySharedPreferences.dart';
import 'package:qrcodereader/utils/constants.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:uuid/uuid.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [Locale('en', 'US'), Locale('it', 'IT')],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'QR Code Scanner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Info> qrScans = new List<Info>();
  EventObject eventObject;
  Uuid uuid = new Uuid();
  BuildContext _mainContext;

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
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.history, color: Colors.white),
            tooltip: AppLocalizations.of(context).history,
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => History()))
                  .then((value) {
                loadInfos();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.clear_all, color: Colors.white),
            tooltip: AppLocalizations.of(context).clearAll,
            onPressed: clearList,
          )
        ],
      ),
      body: buildBody(),
    );
  }

  void clearList() {
    setState(() {
      qrScans.clear();
    });
  }

  Widget buildBody() {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        _mainContext = context;
        return ListView(
            padding: EdgeInsets.all(8.0),
            children: qrScans.map((info) => buildListItem(info)).toList());
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildListItem(Info info) {
    var myFormat = DateFormat('d-MM-yyyy hh:mm');
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: getTitleInfo(info),
            leading: getIconInfo(info),
            trailing: Icon(Icons.arrow_forward_ios),
            //subtitle: Text("Date: " + myFormat.format(info.date)),
            subtitle: Text(
                AppLocalizations.of(context).date + myFormat.format(info.date)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Detail(
                            info: info,
                          )));
            },
          ),
        ],
      ),
    );
  }

  Widget getIconInfo(Info info) {
    if (info is WifiInfo)
      return Icon(Icons.wifi);
    else if (info is UrlInfo)
      return Icon(Icons.link);
    else if (info is GeoInfo)
      return Icon(Icons.gps_fixed);
    else if (info is PlainTextInfo)
      return Icon(Icons.title);
    else if (info is ContactInfo) return Icon(Icons.person);

    return Icon(Icons.error);
  }

  Widget getTitleInfo(Info info) {
    if (info is WifiInfo)
      return Text(AppLocalizations.of(context).wifiContent);
    else if (info is UrlInfo)
      return Text(AppLocalizations.of(context).urlContent);
    else if (info is GeoInfo)
      return Text(AppLocalizations.of(context).geoContent);
    else if (info is PlainTextInfo)
      return Text(AppLocalizations.of(context).plainTextContent);
    else if (info is ContactInfo)
      return Text(AppLocalizations.of(context).contactContent);

    return Text("General");
  }

  void scan() async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.disabled) {
      Scaffold.of(_mainContext).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).cameraDenied),
        action: SnackBarAction(
          label: AppLocalizations.of(context).openSettings,
          onPressed: () async {
            await PermissionHandler().openAppSettings();
          },
        ),
      ));
    } else {
      String cameraScanResult = await scanner.scan();
      parseResult(cameraScanResult);
    }
  }

  void parseResult(String cameraScanResult) async {
    if (cameraScanResult.startsWith('WIFI')) {
      String splitString = cameraScanResult.split('WIFI:')[1];
      if (splitString.contains(';')) {
        List<String> values = splitString.split(';');
        WifiInfo wifiInfo;
        String type, ssid, password;

        for (String value in values) {
          if (value.contains(':')) {
            if (value.startsWith('T'))
              type = value.split(':')[1].trim();
            else if (value.startsWith('S'))
              ssid = value.split(':')[1].trim();
            else if (value.startsWith('P'))
              password = value.split(':')[1].trim();
          }

          wifiInfo = new WifiInfo(uuid.v4(), type, ssid, password);
        }

        EventObject eventObject =
            await MySharedPreferences.saveInfoPrefs(wifiInfo);
        if (eventObject.id == Events.INFO_CREATED_SUCCESSFULLY) {
          setState(() {
            qrScans.add(wifiInfo);
          });
        }
      }
    } else if (cameraScanResult.startsWith('geo')) {
      String splitString = cameraScanResult.split('geo:')[1];
      if (splitString.contains(',')) {
        double longitude = double.parse(splitString.split(',')[0]);
        double latitude = double.parse(splitString.split(',')[1]);

        GeoInfo geoInfo = new GeoInfo(uuid.v4(), latitude, longitude);
        EventObject eventObject =
            await MySharedPreferences.saveInfoPrefs(geoInfo);

        if (eventObject.id == Events.INFO_CREATED_SUCCESSFULLY) {
          setState(() {
            qrScans.add(geoInfo);
          });
        }
      }
    } else if (cameraScanResult.startsWith('http') ||
        cameraScanResult.startsWith('https') ||
        cameraScanResult.startsWith('www')) {
      UrlInfo urlInfo = new UrlInfo(uuid.v4(), cameraScanResult);

      EventObject eventObject =
          await MySharedPreferences.saveInfoPrefs(urlInfo);
      if (eventObject.id == Events.INFO_CREATED_SUCCESSFULLY) {
        setState(() {
          qrScans.add(urlInfo);
        });
      }
    } else if (cameraScanResult.contains("CARD") ||
        cameraScanResult.contains("VCARD")) {
      if (cameraScanResult.contains('\n')) {
        List<String> splitStrings = cameraScanResult.split('\n');
        String name, fullName, title, org, url, address = "";
        List<String> phoneNumbers = new List<String>();
        List<String> emails = new List<String>();
        String splitString = "";

        for (String data in splitStrings) {
          if (data.startsWith("N:"))
            name = data.split(':')[1].split(';')[1];
          else if (data.startsWith('FN:'))
            fullName = data.split(':')[1].trim();
          else if (data.startsWith('TITLE:'))
            title = data.split(':')[1].trim();
          else if (data.startsWith('TEL')) {
            if (data.contains('VALUE')) {
              List<String> splits = data.split(';');
              if (splits[splits.length - 1].contains('VOICE')) {
                phoneNumbers
                    .add(splits[splits.length - 1].split(':')[1].trim());
              } else if (splits[splits.length - 1].contains('VALUE')) {
                List<String> values = splits[splits.length - 1].split(':');
                phoneNumbers.add(values[values.length - 1].trim());
              }
            } else if (data.contains('VOICE')) {
              splitString = data.split('VOICE:')[1].trim();
              phoneNumbers.add(splitString);
            } else {
              splitString = data.split(':')[1].trim();
              phoneNumbers.add(splitString);
            }
          } else if (data.startsWith('ORG:'))
            org = data.split(':')[1].trim();
          else if (data.startsWith('EMAIL')) {
            if (data.contains(';')) {
              List<String> splits = data.split(';');
              emails.add(splits[splits.length - 1].split(':')[1].trim());
            } else {
              emails.add(data.split(':')[1].trim());
            }
          } else if (data.startsWith('URL:'))
            url = data.split('URL:')[1].trim();
          else if (data.startsWith('ADR')) {
            String splitString = data.split(';;')[1].trim();
            if (splitString != null && splitString.isNotEmpty) {
              List<String> splitStrings = splitString.split(';');
              for (String data in splitStrings) {
                address += data + ',';
              }
              address = address.replaceRange(
                  address.lastIndexOf(','), address.length - 1, '');
            }
          }
        }
        ContactInfo contactInfo = new ContactInfo(uuid.v4(), fullName, name,
            org, title, phoneNumbers, address, emails, url);
        EventObject eventObject =
            await MySharedPreferences.saveInfoPrefs(contactInfo);

        if (eventObject.id == Events.INFO_CREATED_SUCCESSFULLY) {
          setState(() {
            qrScans.add(contactInfo);
          });
        }
      }
    } else {
      PlainTextInfo plainTextInfo =
          new PlainTextInfo(uuid.v4(), cameraScanResult);
      EventObject eventObject =
          await MySharedPreferences.saveInfoPrefs(plainTextInfo);

      if (eventObject.id == Events.INFO_CREATED_SUCCESSFULLY) {
        setState(() {
          qrScans.add(plainTextInfo);
        });
      }
    }
  }
}
