import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/shared_widget/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend/my_api.dart';
import '../loging/Login.dart';
import '../shared_widget/components/components.dart';
import 'editprof.dart';
import 'favourites.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: defaultText(
            text: 'Menu',
            fontSize: 20.0,
            textColor: Colors.white,
            isBold: true),
        backgroundColor: primaryColor,
        leading: BackButton(),
        elevation: 5.0,
      ),
      body: Column(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 115,
              width: 115,
              child: CircleAvatar(
                radius: 55.0,
                backgroundImage: AssetImage('assets/images/patient.png'),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        menuItem(
            text: 'My Profile',
            first_icon: Icons.person_outline,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Edit_prof(),
                ),
              );
            }),
        menuItem(
            text: 'Favourite Articles',
            first_icon: Icons.favorite_border,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Favourites(),
                ),
              );
            }),
        menuItem(
            text: 'LogOut',
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
