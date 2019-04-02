import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class AppointmentCard extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State {
  int _id;
  String _patient;
  String _dentist;
  String _recp;
  String _date;
  String _status;
  String _email;
  String _apmType;
  String _phone;
  String _speciality;



  String get apmType => _apmType;

  String get status => _status;

  String get recp => _recp;

  String get dentist => _dentist;

  String get patient => _patient;

  int get id => _id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {}, child: getCard());
  }

  Card getCard() {
    return Card(
      child: new Column(
        children: <Widget>[
          getTile(this._dentist, this._speciality,
              new Icon(Icons.person, color: Colors.blue, size: 26.0)),
          new Divider(
            color: Colors.blue,
            indent: 16.0,
          ),
          getTile(
              _apmType,
              "",
              new Icon(
                Icons.local_hospital,
                color: Colors.blue,
                size: 26.0,
              )),
          getTile(
              _date,
              "",
              new Icon(
                Icons.calendar_today,
                color: Colors.blue,
                size: 26.0,
              )),
          getTile(
              _email,
              "",
              new Icon(
                Icons.email,
                color: Colors.blue,
                size: 26.0,
              )),
          getTile(
              _phone,
              "",
              new Icon(
                Icons.phone,
                color: Colors.blue,
                size: 26.0,
              )),
          new ListTile(
            leading: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "4.5",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  new Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 38.0,
                  )
                ]),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                Text(
                  "Approved",
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListTile getTile(String title, String subtitle, Icon icon) {
    return new ListTile(
      leading: icon,
      title: new Text(
        title,
        style: new TextStyle(fontWeight: FontWeight.w400),
      ),
      subtitle: new Text(subtitle),
    );
  }

  Future<String> getData() async {
    var response = await http.get(
        'http://192.168.43.99/ICS-324-RESTful-API/advertisement/read.php',
        headers: {"Accept": 'application/json'});
  }
}
