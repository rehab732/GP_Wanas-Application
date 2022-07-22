import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project/therapist_view/menu.dart';
import 'package:flutter_project/therapist_view/Therapist_sessions.dart';
import '../shared_widget/components/components.dart';
import '../therapist_view/TherapistProfile.dart';
import '../shared_widget/colors.dart';
import 'YourPatients.dart';
import 'YourSchedule.dart';
import 'add_appointment.dart';

class therapistBar extends StatefulWidget {
  final String title;

  const therapistBar({Key? key, required this.title}) : super(key: key);

  @override
  State<therapistBar> createState() => _HomelayoutState();
}

const String page1 = "Home";
const String page2 = "Profile";
const String page3 = "Appointment";
const String page4 = "Patients";
const String page5 = "Sessions";

class _HomelayoutState extends State<therapistBar> {
  late List<Widget> _pages;
  late Widget _page1;
  late Widget _page2;
  late Widget _page3;
  late Widget _page4;
  late Widget _page5;
  late int _currentIndex;
  late Widget _currentPage;
  var size, height, width;
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  var urlImage =
      'https://images.unsplash.com/photo-1554080353-a576cf803bda?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cGhvdG98ZW58MHx8MHx8&w=1000&q=80';
  @override
  void initState() {
    super.initState();
    _page1 = Schedule();
    _page2 = EditProfile();
    _page3 = AddAppointment();
    _page4 = YourPatients();
    _page5 = sessions();

    _pages = [_page1, _page2, _page3, _page4, _page5];
    _currentIndex = 0;
    _currentPage = _page1;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: defaultText(
            text: widget.title,
            fontSize: 25.0,
            isBold: true,
            textColor: Colors.white),
        backgroundColor: primaryColor,
        shadowColor: Color.fromRGBO(255, 255, 255, 1),
        elevation: 2.0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => menuScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // This is all you need!
          mouseCursor: SystemMouseCursors.grab,
          selectedFontSize: 15.0,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedIconTheme: IconThemeData(color: primaryColor, size: 40),
          selectedItemColor: primaryColor,
          unselectedIconTheme: IconThemeData(
            color: Colors.grey,
          ),
          unselectedItemColor: Colors.grey[700],
          backgroundColor: Colors.white,
          onTap: (index) {
            _changeTab(index);
          },
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
              label: page1,
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: page2,
              icon: Icon(Icons.person),
            ),
            BottomNavigationBarItem(
              label: page3,
              icon: Icon(Icons.add),
            ),
            BottomNavigationBarItem(
              label: page4,
              icon: Icon(Icons.people),
            ),
            BottomNavigationBarItem(
              label: page5,
              icon: Icon(Icons.alarm),
            ),
          ]),
      //   drawer: NavigationDrawerWidget()
    );
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }
}