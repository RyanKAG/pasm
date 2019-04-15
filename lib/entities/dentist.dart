class Dentist {
  int _id;
  String _name;
  String _email;
  String _specialty;
  String _office;

  Dentist(this._id, this._name, this._email, this._specialty, this._office);

  factory Dentist.fromJson(Map<String, dynamic> json) {
    return Dentist(json['id'], json['name'], json['email'], json['specialty'],
        json['office']);
  }

  String get office => _office;

  String get specialty => _specialty;

  String get email => _email;

  String get name => _name;

  int get id => _id;
}
