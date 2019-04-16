class AppointmentList {
  final List<Appointment> _appointments;

  AppointmentList(this._appointments);

  factory AppointmentList.fromJson(List<dynamic> json) {
    List<Appointment> appointments = new List<Appointment>();

    appointments = json.map((i) => Appointment.fromJson(i)).toList();

    return AppointmentList(appointments);
  }

  List<Appointment> get appointments => _appointments;

  int length() => _appointments.length;
}

class Appointment {
  int id;
  int dentistId;
  String patient;
  String dentist;
  String date;
  String status;
  String apmType;
  String specialty;

  Appointment(
      {this.id,
        this.dentistId,
      this.patient,
      this.dentist,
      this.date,
      this.status,
      this.apmType,
      this.specialty});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
        id: json['id'],
        dentistId: json['dentistId'],
        patient: json['patient'],
        dentist: json['dentist'],
        date: json['date'],
        status: json["status"],
        apmType: json['type'],
        specialty: json['specialty']);
  }

  bool isValidApmPost() {
    return this.dentistId != null &&
        this.apmType != null &&
        this.date != null &&
        this.date.split(' ').length == 2;
  }
}
