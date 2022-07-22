// @dart=2.12
// ignore_for_file: unnecessary_const
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/loging/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend/my_api.dart';
import '../patient_view/patientBar.dart';
import '../shared_widget/colors.dart';
import '../therapist_view/therapistBar.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final bool _isVisible = false;
  bool isLogginPatient = false;
  bool isLogginTherapist = false;
  var size, height, width;

  @override
  void initState() {
    super.initState();
    isLoggin();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: const AssetImage("assets/images/logo.png"),
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: height / 25,
            ),
            const Text(
              "Wanas",
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            SizedBox(
              height: height / 25,
            ),
            const Text(
              'A Place To Feel Better',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  //check if there is token in device ..
  Future<void> isLoggin() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      var data = {
        "token": token,
      };
      var res = await CallApi().postData(data, 'checkType');
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        if (body['type'] == "0") {
          setState(() {
            isLogginPatient = true;
            isLogginTherapist = false;
          });
        } else {
          setState(() {
            isLogginTherapist = true;
            isLogginPatient = false;
          });
        }
      }
    } else {
      setState(() {
        isLogginTherapist = false;
        isLogginPatient = false;
      });
    }
    redirectPath();
  }

  void redirectPath() {
    Timer(const Duration(milliseconds: 1000), () {
      if (isLogginTherapist == true) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const therapistBar(title: 'Wanas')),
            (route) => false);
      } else if (isLogginPatient == true) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const PatientBar(title: 'Wanas')),
            (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()), (route) => false);
      }
    });
  }
}
