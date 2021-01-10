import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcodereader/models/ContactInfo.dart';
import 'package:qrcodereader/models/GeoInfo.dart';
import 'package:qrcodereader/models/Info.dart';
import 'package:qrcodereader/models/PlainTextInfo.dart';
import 'package:qrcodereader/models/UrlInfo.dart';
import 'package:qrcodereader/models/WifiInfo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:native_contact_dialog/native_contact_dialog.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qrcodereader/localization/AppLocalizations.dart';

class Detail extends StatefulWidget {
  Detail({Key key, this.info}) : super(key: key);

  final Info info;

  DetailState createState() => DetailState();
}

class DetailState extends State<Detail> {
  BuildContext _bodyContext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getTitleInfo(widget.info),
        actions: <Widget>[
          buildAppBar(),
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        _bodyContext = context;
        return buildBody();
      }),
    );
  }

  Widget buildAppBar() {
    if (widget.info is PlainTextInfo) {
      return Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: _sharePlainText,
            tooltip: AppLocalizations.of(context).share,
          ),
          IconButton(
            icon: Icon(
              Icons.content_copy,
              color: Colors.white,
            ),
            onPressed: _copyPlainText,
            tooltip: AppLocalizations.of(context).copy,
          )
        ],
      );
    } else if (widget.info is ContactInfo) {
      return Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
            onPressed: _addContact,
            tooltip: AppLocalizations.of(context).addContact,
          )
        ],
      );
    }

    return new Container();
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

  Widget buildBody() {
    if (widget.info is WifiInfo) {
      return buildWifiBody();
    } else if (widget.info is GeoInfo) {
      return buildGeoBody();
    } else if (widget.info is UrlInfo) {
      return buildUrlBody();
    } else if (widget.info is PlainTextInfo) {
      return buildTextBody();
    } else if (widget.info is ContactInfo) {
      return buildContactBody();
    }
    return Container();
  }

  Widget buildWifiBody() {
    WifiInfo wifiInfo = widget.info as WifiInfo;
    return ListView(
      children: <Widget>[
        new SizedBox(
          child: Hero(
            tag: AppLocalizations.of(context).wifiContent,
            createRectTween: _createRectTween,
            child: new Image(
              image: AssetImage("assets/images/wifi.png"),
            ),
          ),
          height: 200.0,
        ),
        listTile(wifiInfo.ssid, Icons.wifi, "WIFI"),
        listTile(wifiInfo.type, Icons.title, "WIFI"),
        listTile(wifiInfo.password, Icons.lock, "WIFI")
      ],
    );
  }

  Widget buildGeoBody() {
    GeoInfo geoInfo = widget.info as GeoInfo;
    return ListView(
      children: <Widget>[
        new SizedBox(
          child: Hero(
            tag: AppLocalizations.of(context).geoContent,
            createRectTween: _createRectTween,
            child: new Image(
              image: AssetImage("assets/images/geo.png"),
            ),
          ),
          height: 200.0,
        ),
        listTile(geoInfo.latitude.toString(), Icons.gps_fixed, "GEO"),
        listTile(geoInfo.longitude.toString(), Icons.gps_fixed, "GEO"),
        listTile(AppLocalizations.of(context).goToMaps, Icons.link, "GEOLINK")
      ],
    );
  }

  Widget buildUrlBody() {
    UrlInfo urlInfo = widget.info as UrlInfo;
    return ListView(
      children: <Widget>[
        new SizedBox(
          child: Hero(
            tag: AppLocalizations.of(context).urlContent,
            createRectTween: _createRectTween,
            child: new Image(
              image: AssetImage("assets/images/URL.png"),
            ),
          ),
          height: 200.0,
        ),
        listTile(urlInfo.titleUrl, Icons.link, "URL"),
        listTile(
            AppLocalizations.of(context).search, Icons.search, "SEARCH URL"),
        listTile(
            AppLocalizations.of(context).copy, Icons.content_copy, "COPY URL"),
        listTile(AppLocalizations.of(context).share, Icons.share, "SHARE URL")
      ],
    );
  }

  Widget buildTextBody() {
    PlainTextInfo plainTextInfo = widget.info as PlainTextInfo;
    return ListView(
      children: <Widget>[
        new SizedBox(
          child: Hero(
            tag: AppLocalizations.of(context).plainTextContent,
            createRectTween: _createRectTween,
            child: new Image(
              image: AssetImage("assets/images/text.jpg"),
            ),
          ),
          height: 200.0,
        ),
        Text(plainTextInfo.text),
      ],
    );
  }

  Widget buildContactBody() {
    ContactInfo contactInfo = widget.info as ContactInfo;
    return ListView(
      children: <Widget>[
        new SizedBox(
          child: Hero(
            tag: AppLocalizations.of(context).contactContent,
            createRectTween: _createRectTween,
            child: new Image(
              image: AssetImage("assets/images/person.jpg"),
            ),
          ),
          height: 200.0,
        ),
        listTile(contactInfo.fullname, Icons.account_box, "FULLNAME"),
        listTile(contactInfo.name, Icons.account_box, "NAME"),
        listTile(contactInfo.titleContact, Icons.title, "TITLE"),
        listTile(contactInfo.org, Icons.work, "ORG"),
        listTile(contactInfo.url, Icons.link, "URL"),
        listTile(contactInfo.address, Icons.home, "ADDRESS"),
        for (String email in contactInfo.emails)
          listTile(email, Icons.email, "EMAIL"),
        for (String phone in contactInfo.phoneNumbers)
          listTile(phone, Icons.phone, "PHONE"),
      ],
    );
  }

  Widget listTile(String text, IconData icon, String tileCase) {
    return new GestureDetector(
      onTap: () {
        switch (tileCase) {
          case "PHONE":
            //_launch("tel:" + contact.phone);
            break;
          case "EMAIL":
            // _launch("mailto:${contact.email}?");
            break;
          case "ADDRESS":
            break;
          case "GEOLINK":
            GeoInfo geoInfo = widget.info as GeoInfo;
            final String url =
                "https://maps.google.com/?q=${geoInfo.longitude.toString()},${geoInfo.latitude.toString()}";
            _launch(url);
            break;
          case "SEARCH URL":
            UrlInfo urlInfo = widget.info as UrlInfo;
            _launch(urlInfo.titleUrl);
            break;
          case "COPY URL":
            UrlInfo urlInfo = widget.info as UrlInfo;
            Clipboard.setData(new ClipboardData(text: urlInfo.titleUrl))
                .then((result) {
              Scaffold.of(_bodyContext).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context).linkCopied),
              ));
            });
            break;
          case "SHARE URL":
            UrlInfo urlInfo = widget.info as UrlInfo;
            Share.share(urlInfo.titleUrl);
            break;
        }
      },
      child: new Column(
        children: <Widget>[
          new ListTile(
            title: new Text(
              text == null || text.isEmpty ? '//' : text,
              style: new TextStyle(
                color: Colors.blueGrey[400],
                fontSize: 20.0,
              ),
            ),
            leading: new Icon(
              icon,
              color: Colors.blue[400],
            ),
          ),
          new Container(
            height: 0.3,
            color: Colors.blueGrey[400],
          )
        ],
      ),
    );
  }

  RectTween _createRectTween(Rect begin, Rect end) {
    return new MaterialRectCenterArcTween(begin: begin, end: end);
  }

  void _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Scaffold.of(_bodyContext).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).urlNotValid)));
    }
  }

  void _copyPlainText() {
    PlainTextInfo plainTextInfo = widget.info as PlainTextInfo;
    Clipboard.setData(new ClipboardData(text: plainTextInfo.text))
        .then((result) {
      Scaffold.of(_bodyContext).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).textCopied),
      ));
    });
  }

  void _sharePlainText() {
    PlainTextInfo plainTextInfo = widget.info as PlainTextInfo;
    Share.share(plainTextInfo.text);
  }

  void _addContact() {
    ContactInfo contactInfo = widget.info as ContactInfo;

    Iterable<Item> emails = Iterable<Item>.generate(
        contactInfo.emails.length,
        (i) =>
            Item(label: 'email' + i.toString(), value: contactInfo.emails[i]));
    Iterable<Item> phones = Iterable<Item>.generate(
        contactInfo.phoneNumbers.length,
        (i) => Item(
            label: 'phone' + i.toString(), value: contactInfo.phoneNumbers[i]));

    final contactToAdd = Contact(
      givenName: contactInfo.fullname,
      middleName: contactInfo.name,
      familyName: contactInfo.name,
      prefix: contactInfo.name,
      suffix: contactInfo.name,
      company: contactInfo.org,
      jobTitle: contactInfo.titleContact,
      emails: emails,
      phones: phones,
      //postalAddresses: null,
      //avatar: null,
    );

    NativeContactDialog.addContact(contactToAdd).then((result) {
      print(result);
    }).catchError((error) {
      // FlutterError, most likely unsupported operating system.
      print('Error adding contact!');
    });
  }
}
