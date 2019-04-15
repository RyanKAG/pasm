import 'package:flutter/material.dart';
import 'package:pasm/components/appointmentCard.dart';
import 'package:pasm/entities/user.dart';
import 'package:pasm/pages/apm-createpage.dart';

class UserHomepage extends StatefulWidget {
  final User _user;

  UserHomepage(this._user);

  @override
  _UserHomepageState createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  int _selectedIndex = 0;
  List<Widget> pages;
  Widget curretPage;

  @override
  void initState() {
    var allApms = AppointmentCardList(patientID: widget._user.id);
    var confirmedApms =
    AppointmentCardList(patientID: widget._user.id, apmStatus: 5);
    pages = [allApms, confirmedApms, Container()];
    curretPage = allApms;
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
          icon: Icon(Icons.person),
          onPressed: () {},
        ),
      ),
      body: curretPage,
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (ctx) => CreateApmPage(widget._user))),
        child: Icon(Icons.add, size: 36),
      ),
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
          icon: Icon(Icons.calendar_today), title: Text('All')),
      BottomNavigationBarItem(
          icon: Icon(Icons.check_circle_outline), title: Text('Confirmed')),
      BottomNavigationBarItem(
          icon: Icon(Icons.local_hospital), title: Text('Clinics'))
    ];
  }
}
