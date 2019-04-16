import 'package:flutter/material.dart';
import 'package:pasm/helpers/api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _username;
  String _password;
  String _email;
  String _lastName;
  String _firstName;
  DateTime _date = DateTime.now();
  final GlobalKey<FormState> _regFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("in build login");
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: buildLoginForm(context),
          ),
        ),
      ),
    );
  }

  Widget buildLoginForm(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    // run the validators on reload to process async results
    return Form(
      key: this._regFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 100),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 70,
                child: Image.asset('images/logo.png'),
              )),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: TextFormField(
              key: Key('FName'),
              decoration: InputDecoration(
                hintText: 'enter first name',
                labelText: 'First name',
              ),
              style: TextStyle(fontSize: 16.0, color: textTheme.button.color),
              onSaved: (value) => _firstName = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: TextFormField(
              key: Key('LName'),
              decoration: InputDecoration(
                hintText: 'enter last name',
                labelText: 'Last name',
              ),
              style: TextStyle(fontSize: 16.0, color: textTheme.button.color),
              onSaved: (value) => _lastName = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: TextFormField(
              key: Key('username'),
              decoration: InputDecoration(
                hintText: 'Enter username',
                labelText: 'Username',
              ),
              style: TextStyle(fontSize: 16.0, color: textTheme.button.color),
              onSaved: (value) => _username = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: TextFormField(
              key: Key('password'),
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'enter password',
                labelText: 'Password',
              ),
              style: TextStyle(fontSize: 16.0, color: textTheme.button.color),
              onSaved: (value) => _password = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: TextFormField(
              key: Key('Email'),
              decoration: InputDecoration(
                hintText: 'enter email',
                labelText: 'Eamil',
              ),
              style: TextStyle(fontSize: 16.0, color: textTheme.button.color),
              onSaved: (value) => _email = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, top: 5),
            child: RaisedButton(
              color: Color.fromRGBO(0, 129, 150, 100),
              onPressed: _submit,
              child: Text('Register', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    _regFormKey.currentState.save();

    FocusScope.of(context).requestFocus(new FocusNode());

    print(_date);
    print(_firstName);
    var res = await http.post(Api.getUrl('users/create.php'),
        body: json.encode({
          "FName": _firstName,
          "LName": _lastName,
          "Hashed_pw": _password,
          "UserName": _username,
          "Email": _email,
          "Reg_Date": _date.toString().split(' ')[0],
          "type_ID": 4,
          "status_ID": 1
        }));
    if (res.statusCode == 201)
      Navigator.pop(context);
    else
      print(res.statusCode);
  }
}
