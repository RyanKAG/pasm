import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pasm/entities/appointment.dart';
import 'package:pasm/helpers/api.dart';

class AppointmentCardList extends StatefulWidget {
  final int patientID;
  final int apmStatus;

  AppointmentCardList({@required this.patientID, this.apmStatus});

  @override
  _AppointmentCardListState createState() => _AppointmentCardListState();
}

class _AppointmentCardListState extends State<AppointmentCardList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: getAppointments(),
            builder: (BuildContext context, AsyncSnapshot<AppointmentList> sp) {
              if (sp.data == null) {
                return Container(child: Center(child: Text('loading')));
              } else {
                return ListView.builder(
                    itemCount: sp.data.appointments.length,
                    itemBuilder: (BuildContext ctx, int i) {
                      final card = sp.data.appointments[i];
                      return Dismissible(
                        key: Key(card.id.toString()),
                        child: AppointmentCard(sp.data.appointments[i]),
                        background: Container(color: Colors.red),
                        onDismissed: (direction) {
                          delete(card.id);
                        },
                      );
                    });
              }
            }));
  }

  Future<AppointmentList> getAppointments() async {
    int id = widget.patientID;
    int sid = widget.apmStatus;
    String endpoint;

    sid == null
        ? endpoint = 'readAll.php?id=$id'
        : endpoint = 'readStatus.php?id=$id&sid=$sid';

    endpoint = 'appointment/' + endpoint;

    return http.get(Api.getUrl(endpoint)).then((response) {
      print(response.statusCode);
      if (response.statusCode == 200)
        return AppointmentList.fromJson(json.decode(response.body));
    });
  }

  @override
  void initState() {
    super.initState();
    getAppointments();
  }

  void delete(int i) async {
    var response = await http.get(
        'http://192.168.43.99:81/ICS-324-RESTful-API/appointment/delete.php?id=' +
            i.toString());
    print(response.statusCode);
  }
}

class AppointmentCard extends StatefulWidget {
  final Appointment _appointment;

  AppointmentCard(this._appointment);

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {}, child: getCard(context));
  }

  Widget getCard(BuildContext context) {
    return Card(
      child: new Column(
        children: <Widget>[
          getTile(widget._appointment.dentist, widget._appointment.specialty,
              new Icon(Icons.person, color: Colors.blue, size: 26.0)),
          new Divider(
            color: Colors.blue,
            indent: 16.0,
          ),
          getTile(
              widget._appointment.apmType,
              "",
              new Icon(
                Icons.local_hospital,
                color: Colors.blue,
                size: 26.0,
              )),
          getTile(
              widget._appointment.date,
              "",
              new Icon(
                Icons.calendar_today,
                color: Colors.blue,
                size: 26.0,
              )),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                Text(
                  widget._appointment.status,
                  style: TextStyle(
                      color: widget._appointment.status == 'Canceled'
                          ? Colors.red
                          : widget._appointment.status == 'unconfirmed'
                              ? Colors.orange
                              : Colors.green),
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
