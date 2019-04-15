import 'package:pasm/entities/dentist.dart';

class ClinicList {
  List<Clinic> _clincs;

  List<Clinic> get clincs => _clincs;

  ClinicList(this._clincs);

  factory ClinicList.fromJson(List<dynamic> json) {
    List<Clinic> clinics = List<Clinic>();

    clinics = json.map((i) => Clinic.fromJson(i)).toList();

    return ClinicList(clinics);
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

  Clinic(
      {this.id,
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
