import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pasm/entities/appointment.dart';
import 'package:pasm/entities/clinic.dart';
import 'package:pasm/entities/user.dart';
import 'package:pasm/helpers/api.dart';
import 'package:pasm/pages/apmeditpage.dart';
import 'package:pasm/components/dentistcard.dart';

class ClinicCardList extends StatefulWidget {
  @override
  _ClinicCardListState createState() => _ClinicCardListState();
}

class _ClinicCardListState extends State<ClinicCardList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: getClinics(),
            builder: (BuildContext context, AsyncSnapshot<List<Clinic>> sp) {
              if (sp.data == null) {
                return Container(child: Center(child: Text('loading')));
              } else {
                return ListView.builder(
                    itemCount: sp.data.length,
                    itemBuilder: (BuildContext ctx, int i) {
                      return ClinicCard(sp.data[i]);
                    });
              }
            }));
  }

  Future<List<Clinic>> getClinics() async {
    var response = await http.get(Api.getUrl('clinic/readAll.php'));
    if (response.statusCode == 200) {
      List<Clinic> clinics =
          ClinicList.fromJson(json.decode(response.body)).clinics;
      return clinics;
    }
    return null;
  }
}

class ClinicCard extends StatefulWidget {
  final Clinic _clinic;

  ClinicCard(this._clinic);

  @override
  _ClinicCardState createState() => _ClinicCardState();
}

class _ClinicCardState extends State<ClinicCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {}, child: getCard(context));
  }

  Widget getCard(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => DentistCardList(widget._clinic.dentists))),
        child: Card(
          child: new Column(
            children: <Widget>[
              getTile(widget._clinic.name, widget._clinic.services.toString(),
                  new Icon(Icons.person, color: Colors.blue, size: 26.0)),
              new Divider(
                color: Colors.blue,
                indent: 16.0,
              ),
              getTile(widget._clinic.website, "", Icon(Icons.web)),
              getTile(
                  widget._clinic.email != null ? widget._clinic.email : 'N/A',
                  "",
                  Icon(Icons.mail)),
              getTile(
                  widget._clinic.location != null
                      ? widget._clinic.location
                      : 'N/A',
                  "",
                  Icon(Icons.location_on)),
              getTile(
                  widget._clinic.rating,
                  "",
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ))
            ],
          ),
        ));
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
