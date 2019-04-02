import 'package:flutter/material.dart';
import 'package:pasm/entities/user.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  User user;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _emailCtrl = TextEditingController();
  var _passCtrl = TextEditingController();
  var _labelCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 100,
        child: Image.asset('images/logo.png'),
      ),
    );
    final emailField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailCtrl,
      autofocus: false,
      decoration: InputDecoration(
          hintText: 'Username or Email',
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
    );
    final passwordField = TextFormField(
      autofocus: false,
      controller: _passCtrl,
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
    );
    var errorLabel;
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Material(
        shadowColor: Colors.blueAccent.shade100,
        child: MaterialButton(
          minWidth: 360,
          height: 42,
          onPressed: () async {
            try {
              widget.user = await _login(_emailCtrl.text, _passCtrl.text);
            } catch (e) {
              errorLabel = Text(e);
            }
          },
          color: Colors.blueAccent,
          child: Text(
            'Log In',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );

    final forgotLabel = InkWell(
      child: Text(
        'Forgot Password',
        style: TextStyle(color: Colors.redAccent),
      ),
      onTap: () {
        print("hello");
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );

    final registerLabel = InkWell(
      child: Text(
        'Register!',
        style: TextStyle(color: Colors.redAccent),
      ),
      onTap: () {
        print("hello");
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: <Widget>[
            logo,
            SizedBox(
              height: 48,
            ),
            emailField,
            SizedBox(
              height: 8,
            ),
            passwordField,
            SizedBox(
              height: 24,
            ),
            loginButton,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                registerLabel,
                SizedBox(
                  width: 25,
                ),
                forgotLabel
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<User> _login(String username, String password) async {
    print(username + " " + password);
    http
        .post('http://192.168.43.99/ICS-324-RESTful-API/users/login.php',
            body: json.encode({'UserName': username.trim(), 'password': password.trim()}))
        .then((response) {
      final int statusCode = response.statusCode;
      switch (statusCode) {
        case 422:
          throw new Exception('invalid password');
        case 401:
          throw new Exception('could not find user');
        case 500:
          throw new Exception('There is a problem on our side');
      }
      print(response.body);
      return User.fromJson(json.decode(response.body));
    });
  }
}
