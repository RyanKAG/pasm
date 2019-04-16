import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pasm/entities/appointment.dart';
import 'package:pasm/entities/clinic.dart';
import 'package:pasm/entities/dentist.dart';
import 'package:pasm/entities/user.dart';
import 'package:pasm/helpers/api.dart';
import 'package:pasm/pages/apmeditpage.dart';

class DentistCardList extends StatefulWidget {
  List<Dentist> dentists;

  DentistCardList(this.dentists);

  @override
  _DentistCardListState createState() => _DentistCardListState();
}

class _DentistCardListState extends State<DentistCardList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dentists'),
      ),
      body: Container(
          child: ListView.builder(
              itemCount: widget.dentists.length,
              itemBuilder: (BuildContext ctx, int i) {
                return DentistCard(widget.dentists[i]);
              })),
    );
  }
}

class DentistCard extends StatefulWidget {
  final Dentist _dentist;

  DentistCard(this._dentist);

  @override
  _DentistCardState createState() => _DentistCardState();
}

class _DentistCardState extends State<DentistCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {}, child: getCard(context));
  }

  Widget getCard(BuildContext context) {
    return Card(
      child: new Column(
        children: <Widget>[
          getTile(widget._dentist.name, widget._dentist.specialty,
              new Icon(Icons.person, color: Colors.blue, size: 26.0)),
          new Divider(
            color: Colors.blue,
            indent: 16.0,
          ),
          getTile(
              widget._dentist.website != null ? widget._dentist.website : "N/A",
              "",
              Icon(Icons.web)),
          getTile(widget._dentist.email != null ? widget._dentist.email : 'N/A',
              "", Icon(Icons.mail)),
          getTile(
              widget._dentist.office != null ? widget._dentist.office : 'N/A',
              "",
              Icon(Icons.location_on)),
          getTile(
              widget._dentist.rating != null ? widget._dentist.rating : "N/A",
              "",
              Icon(
                Icons.star,
                color: Colors.yellow,
              ))
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
