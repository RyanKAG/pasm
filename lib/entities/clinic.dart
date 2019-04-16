import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pasm/entities/dentist.dart';
import 'package:pasm/helpers/api.dart';

class ClinicList {
  List<Clinic> _clinics;

  List<Clinic> get clinics => _clinics;

  ClinicList(this._clinics);

  factory ClinicList.fromJson(List<dynamic> json) {
    List<Clinic> clinics = List<Clinic>();

    clinics = json.map((i) => Clinic.fromJson(i)).toList();

    return ClinicList(clinics);
  }

  Clinic getClinicWithDentistId(int id) {
    for (int i = 0; i < _clinics.length; i++)
      for (int j = 0; j < _clinics[i].dentists.length; j++)
        if (_clinics[i].dentists[j].id == id)
          return _clinics[i];

    return null;
  }
}

class Clinic {
  int id;
  List<Dentist> dentists;
  List<String> services;
  double rating;
  String name;
  String website;
  String email;
  String status;

  Clinic({this.id,
    this.name,
    this.dentists,
    this.services,
    this.website,
    this.email,
    this.status});

  factory Clinic.fromJson(Map<String, dynamic> json) {
    var list = json['dentists'] as List;

    List<Dentist> dentistList = list.map((i) => Dentist.fromJson(i)).toList();

    return Clinic(
        id: json['id'],
        name: json['name'],
        dentists: dentistList,
        services: json['services'].toString().split('-'),
        website: json['website'],
        email: json['email'],
        status: json['status']);
  }
}
