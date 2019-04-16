import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pasm/entities/appointment.dart';
import 'package:pasm/entities/user.dart';
import 'package:pasm/helpers/api.dart';
import 'package:pasm/pages/apmeditpage.dart';

class AppointmentCardList extends StatefulWidget {
  final int apmStatus;
  final User user;

  AppointmentCardList({@required this.apmStatus, this.user});

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
                      print(card.dentistId);
                      return Dismissible(
                        key: Key(card.id.toString()),
                        child: AppointmentCard(
                            sp.data.appointments[i], widget.user),
                        background: Container(color: Colors.green),
                        onDismissed: (direction) {
                          confirmApm(card.id, 5);
                        },
                      );
                    });
              }
            }));
  }

  Future<AppointmentList> getAppointments() async {
    int sid = widget.apmStatus;
    String endpoint = 'readOneStatus.php?sid=$sid';

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

  void confirmApm(int apmId, int status) async {
    var response = await http.get(Api.getUrl('/appointment/confirm.php?id=') +
        apmId.toString() +
        "&sid=" +
        status.toString() +
        "&rid=" +
        widget.user.id.toString());
    print(response.statusCode);
  }
}

class AppointmentCard extends StatefulWidget {
  final Appointment _appointment;
  final User _user;

  AppointmentCard(this._appointment, this._user);

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
          ListTile(
              leading: IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 22,
                    color: Colors.orange,
                  ),
                  onPressed: () =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) =>
                                  ApmEditPage(
                                    apm: widget._appointment,
                                    user: widget._user,
                                  ))))),
          getTile(widget._appointment.dentist, widget._appointment.specialty,
              new Icon(Icons.person, color: Colors.blue, size: 26.0)),
          new Divider(
            color: Colors.blue,
            indent: 16.0,
          ),
          getTile(widget._appointment.patient, "", Icon(Icons.perm_identity)),
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
}
