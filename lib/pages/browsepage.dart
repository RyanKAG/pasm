import 'package:flutter/material.dart';
import 'package:pasm/components/cliniccard.dart';
import 'package:pasm/entities/user.dart';
import 'package:pasm/pages/apm-createpage.dart';

class BrowsePage extends StatefulWidget {
  @override
  _BrowsePageState createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  int _selectedIndex = 0;
  List<Widget> pages;
  Widget curretPage;

  @override
  void initState() {
    var allClinics = ClinicCardList();
    pages = [allClinics, Container()];
    curretPage = allClinics;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade400,
        title: Text('Clinics'),
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
      _selectedIndex = index;
      curretPage = pages[index];
    });
  }

  List<BottomNavigationBarItem> getBottomNavBar() {
    return [
      BottomNavigationBarItem(
          icon: Icon(
            Icons.local_hospital,
            color: Colors.red,
          ),
          title: Text('Clinics')),
      BottomNavigationBarItem(
          icon: Icon(Icons.refresh), title: Text('Confirmed')),
    ];
  }
}
