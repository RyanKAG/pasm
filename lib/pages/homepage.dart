import 'package:flutter/material.dart';
import 'package:pasm/components/appointment.dart';
import 'package:pasm/entities/user.dart';

class Homepage extends StatefulWidget {
  User _user;

  Homepage(this._user);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 1;

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
      body: ListView(
        children: <Widget>[AppointmentCard()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: getBottomNavBar(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  List<BottomNavigationBarItem> getBottomNavBar() {
    return [
      BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today), title: Text('Active')),
      BottomNavigationBarItem(
          icon: Icon(Icons.check_circle_outline), title: Text('Completed')),
      BottomNavigationBarItem(
          icon: Icon(Icons.star_border), title: Text('Rated'))
    ];
  }
}
