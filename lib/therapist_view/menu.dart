import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/shared_widget/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/my_api.dart';
import '../loging/Login.dart';
import '../shared_widget/components/components.dart';

class menuScreen extends StatelessWidget {
  const menuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            defaultText(text: 'Menu', fontSize: 20.0, textColor: Colors.white),
        backgroundColor: primaryColor,
        shadowColor: Colors.white,
        leading: BackButton(),
        elevation: 0.0,
      ),
      body: Column(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 115,
              width: 115,
              child: CircleAvatar(
                radius: 55.0,
                backgroundImage: AssetImage('assets/images/therapist.png'),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        menuItem(
            text: 'Logout',
            first_icon: Icons.login_outlined,
            press: () async {
              logout(context);
            }),
      ]),
      //bottomNavigationBar: customNavBar(selectedmenu: MenueState.home,),
    );
  }

  void logout(BuildContext context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
    };

    var res = await CallApi().postData(data, 'logout');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', '');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Login()));
    } else {
      print(body['message']);
    }
  }
}
