import 'package:flutter/material.dart';
import 'package:pasm/entities/clinic.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pasm/helpers/api.dart';
import 'package:pasm/entities/dentist.dart';
import 'package:pasm/entities/appointment.dart';
import 'package:pasm/entities/user.dart';

class CreateApmPage extends StatefulWidget {
  final User _user;

  CreateApmPage(this._user);

  @override
  _CreateApmPageState createState() => _CreateApmPageState();
}

class _CreateApmPageState extends State<CreateApmPage> {
  Appointment apm = new Appointment();
  Future<List<Clinic>> clinics;
  Clinic selectedClinic;
  String selectedType = "";
  Dentist selectedDentist;

  DateTime _selectedDate = DateTime.now();
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    clinics = getClinics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Appointment'),
      ),
      body: Container(
        child: getFutureBuilder(),
      ),
    );
  }

  Widget getFutureBuilder() {
    bool isEmptyDate = apm.date == null;
    return FutureBuilder<List<Clinic>>(
        future: clinics,
        builder: (BuildContext ctx, AsyncSnapshot<List<Clinic>> sp) {
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
                    DropdownButton<Clinic>(
                      isExpanded: true,
                      items: sp.data
                          .map((clinic) => DropdownMenuItem<Clinic>(
                                value: clinic,
                                child: Text(clinic.name),
                              ))
                          .toList(),
                      value: selectedClinic,
                      onChanged: (clinic) {
                        setState(() {
                          selectedClinic = clinic;
                        });
                      },
                    ),
                    DropdownButton<Dentist>(
                      isExpanded: true,
                      items: selectedClinic.dentists
                          .map((dentist) => DropdownMenuItem<Dentist>(
                                child: Text(dentist.name),
                                value: dentist,
                              ))
                          .toList(),
                      value: selectedClinic.dentists.contains(selectedDentist)
                          ? selectedDentist
                          : null,
                      onChanged: (dentist) {
                        setState(() {
                          selectedDentist = dentist;
                          apm.dentistId = dentist.id;
                        });
                      },
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      items: selectedClinic.services
                          .map((type) => DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      value: selectedClinic.services.contains(selectedType)
                          ? selectedType
                          : null,
                      onChanged: (type) {
                        setState(() {
                          apm.apmType = type;
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
                      onPressed: () =>
                          !isEmptyDate ? _selectTime(context) : null,
                      child: Text('Select time'),
                      color: !isEmptyDate ? Colors.blueAccent : Colors.white30,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    RaisedButton(
                      onPressed: apm.isValidApmPost() ? _handleSubmition : null,
                      child: Text('SUBMIT'),
                      color: apm.isValidApmPost()
                          ? Colors.blueAccent
                          : Colors.white30,
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
        apm.date = picked.toString().split(' ')[0].trim();
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _time);

    if (picked != null && apm.date.isNotEmpty && apm.date != null) {
      setState(() {
        apm.date = apm.date.split(' ')[0].trim() +
            " " +
            picked.hour.toString() +
            ':' +
            picked.minute.toString() +
            ':00';
        print(apm.date);
      });
    }
  }

  _handleSubmition() async {
    var response = await http.post(Api.getUrl('appointment/create.php'),
        body: json.encode({
          'date_time': apm.date,
          'dentistId': apm.dentistId,
          'type': apm.apmType,
          'patientId': widget._user.id
        }));
    if (response.statusCode == 201) Navigator.pop(context);
  }

  Future<List<Clinic>> getClinics() async {
    var response = await http.get(Api.getUrl('clinic/readAll.php'));
    if (response.statusCode == 200) {
      List<Clinic> clinics =
          ClinicList.fromJson(json.decode(response.body)).clincs;
      setState(() {
        selectedClinic = clinics[0];
      });
      return clinics;
    }
    return null;
  }
}
