import 'package:flutter/material.dart';
import 'package:flutter_project/patient_view/Chatbot.dart';
import 'package:flutter_project/patient_view/sessions.dart';
import 'package:flutter_project/shared_widget/colors.dart';
import 'package:flutter_project/shared_widget/components/components.dart';
import 'Accountscreen.dart';
import 'PatientHome.dart';
import 'TherapySessions.dart';
import 'main_awareness_page.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

const String page1 = "Home";
const String page2 = "Awareness";
const String page3 = "ChatBot";
const String page4 = "Book";
const String page5 = "Sessions";

class PatientBar extends StatefulWidget {
  final String title;
  const PatientBar({Key? key, required this.title}) : super(key: key);
  @override
  State<PatientBar> createState() => _HomelayoutState();
}

class _HomelayoutState extends State<PatientBar> {
  late List<Widget> _pages;
  late Widget _page1;
  late Widget _page2;
  late Widget _page3;
  late Widget _page4;
  late Widget _page5;

  late int _currentIndex;
  late Widget _currentPage;
  var size, height, width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: defaultText(
            text: '  ' + widget.title,
            fontSize: 25.0,
            isBold: true,
            textColor: Colors.white),
        backgroundColor: primaryColor,
        elevation: 2.0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dynamic conversationObject = {
            'appId': '3f64cc2ce76eda064e9b3fb104775bdfb',
          };
          KommunicateFlutterPlugin.buildConversation(conversationObject)
              .then((clientConversationId) {
            print("Conversation builder success : " +
                clientConversationId.toString());
          }).catchError((error) {
            print("Conversation builder error : " + error.toString());
          });
        },
        tooltip: "ChatBot",
        child: Image.asset('assets/images/chatBot.png'),
        elevation: 4.0,
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          mouseCursor: SystemMouseCursors.grab,
          selectedFontSize: 15,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          selectedIconTheme: const IconThemeData(color: primaryColor, size: 20),
          selectedItemColor: primaryColor,
          unselectedIconTheme: const IconThemeData(
            color: Colors.grey,
          ),
          unselectedItemColor: Colors.grey[700],
          backgroundColor: Colors.white,
          onTap: (index) {
            _changeTab(index);
            if (index == 2) {}
          },
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
              label: page1,
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: page2,
              icon: Icon(Icons.article),
            ),
            BottomNavigationBarItem(
              label: page3,
              icon: Icon(Icons.add),
            ),
            BottomNavigationBarItem(
              label: page4,
              icon: Icon(Icons.add),
            ),
            BottomNavigationBarItem(
              label: page5,
              icon: Icon(Icons.timelapse),
            ),
          ]),
      //drawer: const NavigationDrawerWidget()
    );
  }

  @override
  void initState() {
    super.initState();
    _page1 = patientHome();
    _page2 = MainAwarenessPage();
    _page3 = Chatbot();
    _page4 = AllTherapists();
    _page5 = MySession();

    //add pages to list page...
    _pages = [_page1, _page2, _page3, _page4, _page5];

    //set patient home as default / active page ..
    _currentIndex = 0;
    _currentPage = _page1;
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }
}
