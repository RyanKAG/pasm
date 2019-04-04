import 'dart:async';
import 'package:pasm/entities/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pasm/pages/homepage.dart';
class LoginPage extends StatefulWidget {
  User _user;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // maintains validators and state of form fields
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  // manage state of modal progress HUD widget
  bool _isInAsyncCall = false;

  bool _isInvalidAsyncUser = false; // managed after response from server
  bool _isInvalidAsyncPass = false; // managed after response from server

  String _username;
  String _password;
  bool _isLoggedIn = false;

  // validate user name
  String _validateUserName(String userName) {
    if (userName.length < 8) {
      return 'Username must be at least 8 characters';
    }

    if (_isInvalidAsyncUser) {
      // disable message until after next async call
      _isInvalidAsyncUser = false;
      return 'Incorrect user name';
    }

    return null;
  }

  // validate password
  String _validatePassword(String password) {
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (_isInvalidAsyncPass) {
      // disable message until after next async call
      _isInvalidAsyncPass = false;
      return 'Incorrect password';
    }

    return null;
  }

  Future<int> login() async {
    return http
        .post('http://192.168.43.99:81/ICS-324-RESTful-API/users/login.php',
        body: json.encode({'UserName': _username, 'password': _password}))
        .then((response) {
      if (response.statusCode == 200)
        widget._user = User.fromJson(json.decode(response.body));
      print(widget._user.fname);
      return response.statusCode;
    });
  }

  void _submit() {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();

      // dismiss keyboard during async call
      FocusScope.of(context).requestFocus(new FocusNode());

      // start the modal progress HUD
      setState(() {
        _isInAsyncCall = true;
      });

      // Simulate a service call
      login().then((statusCode) {
        setState(() {
          if (statusCode != 401 && statusCode != 204) {
            _isInvalidAsyncUser = false;
            if (statusCode != 422) {
              // username and password are correct
              _isInvalidAsyncPass = false;
              _isLoggedIn = true;
            } else
              // username is correct, but password is incorrect
              _isInvalidAsyncPass = true;
          } else {
            // incorrect username and have not checked password result
            _isInvalidAsyncUser = true;
            // no such user, so no need to trigger async password validator
            _isInvalidAsyncPass = false;
          }
          // stop the modal progress HUD
          _isInAsyncCall = false;
        });
        if (_isLoggedIn)
          // do something
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Homepage(widget._user)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: ModalProgressHUD(
            child: SingleChildScrollView(
              child: Container(
                child: buildLoginForm(context),
              ),
            ),
            inAsyncCall: _isInAsyncCall,
            // demo of some additional parameters
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
          )),
    );
  }

  Widget buildLoginForm(BuildContext context) {
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    // run the validators on reload to process async results
    _loginFormKey.currentState?.validate();
    return Form(
      key: this._loginFormKey,
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
              key: Key('username'),
              decoration: InputDecoration(
                  hintText: 'Enter username',
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person,
                      color: Color.fromRGBO(0, 129, 150, 100))),
              style: TextStyle(fontSize: 16.0, color: textTheme.button.color),
              validator: _validateUserName,
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
                  prefixIcon: Icon(Icons.vpn_key,
                      color: Color.fromRGBO(0, 129, 150, 100))),
              style: TextStyle(fontSize: 16.0, color: textTheme.button.color),
              validator: _validatePassword,
              onSaved: (value) => _password = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, top: 5),
            child: RaisedButton(
              color: Color.fromRGBO(0, 129, 150, 100),
              onPressed: _submit,
              child: Text('Login', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
