import 'package:flutter/material.dart';
import 'package:pasm/components/apmCardRec.dart';
import 'package:pasm/entities/clinic.dart';
import 'package:pasm/entities/user.dart';

class ReceptionistHomepage extends StatefulWidget {
  final User _user;

  ReceptionistHomepage(this._user);

  @override
  _ReceptionistHomepageState createState() => _ReceptionistHomepageState();
}

class _ReceptionistHomepageState extends State<ReceptionistHomepage> {
  int _selectedIndex = 0;
  List<Widget> pages;
  Widget curretPage;

  @override
  void initState() {
    var unconfirmedApm = AppointmentCardList(apmStatus: 4, user: widget._user);
    var confirmedApms = AppointmentCardList(apmStatus: 5, user: widget._user);
    pages = [unconfirmedApm, confirmedApms, Container()];
    curretPage = unconfirmedApm;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade400,
        title: Text('Appointment'),
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: curretPage,
      bottomNavigationBar: BottomNavigationBar(
        items: getBottomNavBar(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      print(widget._user.id);
      _selectedIndex = index;
      curretPage = pages[index];
    });
  }

  List<BottomNavigationBarItem> getBottomNavBar() {
    return [
      BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today), title: Text('Unconfirmed')),
      BottomNavigationBarItem(
          icon: Icon(Icons.check_circle_outline), title: Text('Confirmed')),
      BottomNavigationBarItem(
          icon: Icon(Icons.local_hospital), title: Text('Clinics'))
    ];
  }
}
