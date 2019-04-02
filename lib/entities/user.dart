class User{
  final int _id;
  String _username;
  final String _fname;
  final String _lname;
  final String _email;
  final String _regDat;
  final int _typeId;
  final int _statusId;

  User(this._id, this._username, this._fname, this._lname, this._email,
      this._regDat, this._typeId, this._statusId);

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      json["id"],
      json['username'],
      json['fname'],
      json['lname'],
      json['email'],
      json['regDate'],
      json['typeId'],
      json['statusId'],
    );
  }

  String getFullName(){
    return this._fname+" "+this._lname;
  }


  int get statusId => _statusId;

  int get typeId => _typeId;

  String get regDat => _regDat;

  String get email => _email;

  String get lname => _lname;

  String get fname => _fname;

  String get username => _username;

  int get id => _id;


}