import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pasm/entities/appointment.dart';
import 'package:pasm/entities/clinic.dart';
import 'package:pasm/entities/dentist.dart';
import 'package:pasm/entities/user.dart';
import 'package:pasm/helpers/api.dart';

class ApmEditPage extends StatefulWidget {
  final Appointment apm;
  final User user;

  ApmEditPage({this.apm, this.user});

  @override
  _ApmEditPageState createState() => _ApmEditPageState();
}

class _ApmEditPageState extends State<ApmEditPage> {
  Future<ClinicList> clinics;
  Dentist selectedDentist;
  String selectedType;

  DateTime _selectedDate = DateTime.now();
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Appointment ID:#' + widget.apm.id.toString()),
      ),
      body: getFutureBuilder(),
    );
  }

  Widget getFutureBuilder() {
    return FutureBuilder<ClinicList>(
        future: clinics,
        builder: (BuildContext ctx, AsyncSnapshot<ClinicList> sp) {
          Clinic clinic = sp.data.getClinicWithDentistId(widget.apm.dentistId);
          if (sp.data == null) {
            return Center(
              child: Text('Loading'),
            );
          } else {
            return Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    DropdownButton<Dentist>(
                      isExpanded: true,
                      items: clinic.dentists
                          .map((dentist) => DropdownMenuItem<Dentist>(
                                child: Text(dentist.name),
                                value: dentist,
                              ))
                          .toList(),
                      value: selectedDentist,
                      onChanged: (dentist) {
                        setState(() {
                          selectedDentist = dentist;
                          widget.apm.dentistId = dentist.id;
                        });
                      },
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      items: clinic.services
                          .map((type) => DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      value: selectedType,
                      onChanged: (type) {
                        setState(() {
                          widget.apm.apmType = type;
                          selectedType = type;
                        });
                      },
                    ),
                    RaisedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select Date'),
                      color: Colors.blueAccent,
                    ),
                    RaisedButton(
                      onPressed: () => _selectTime(context),
                      child: Text('Select time'),
                      color: Colors.blueAccent,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    RaisedButton(
                      onPressed: _handleSubmition,
                      child: Text('SUBMIT'),
                      color: Colors.blueAccent,
                    )
                  ],
                ));
          }
        });
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime lastDate = DateTime.now().add(Duration(days: 365));
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: _date,
        lastDate: lastDate);

    if (picked != null)
      setState(() {
        widget.apm.date = picked.toString().split(' ')[0].trim();
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _time);

    if (picked != null &&
        widget.apm.date.isNotEmpty &&
        widget.apm.date != null) {
      setState(() {
        widget.apm.date = widget.apm.date.split(' ')[0].trim() +
            " " +
            picked.hour.toString() +
            ':' +
            picked.minute.toString() +
            ':00';
      });
    }
  }

  Future<ClinicList> getClinics() async {
    var response = await http.get(Api.getUrl('clinic/readAll.php'));
    if (response.statusCode == 200) {
      ClinicList clinics = ClinicList.fromJson(json.decode(response.body));
      return clinics;
    }
    return null;
  }

  @override
  void initState() {
    clinics = getClinics();
  }

  void _handleSubmition() async {
    var response = await http.post(Api.getUrl('appointment/update.php'),
        body: json.encode({
          "dentistId": widget.apm.dentistId,
          "type": widget.apm.apmType,
          "rid": widget.user.id,
          "date_time": widget.apm.date,
          "id": widget.apm.id.toString()
        }));
    if (response.statusCode == 201) Navigator.pop(context);
  }
}
