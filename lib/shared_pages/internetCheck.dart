import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/loging/Splash.dart';
import '../therapist_view/therapistBar.dart';

import '../loging/Login.dart';
import '../patient_view/patientBar.dart';

class HomeConnect extends StatefulWidget {
  const HomeConnect({Key? key}) : super(key: key);

  @override
  _HomeConnectState createState() => _HomeConnectState();
}

class _HomeConnectState extends State<HomeConnect> {
  var iswificonnected;
  var isInternetOn;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isInternetOn != null && iswificonnected != null
          ? isInternetOn || iswificonnected
              ? Splash()
              : buildAlertDialog()
          : buildAlertDialog(),
    );
  }

  AlertDialog buildAlertDialog() {
    return const AlertDialog(
      title: Text(
        "You are not Connected to Internet",
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }

  void GetConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
        iswificonnected = false;
      });
    } else if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        iswificonnected = false;
        isInternetOn = true;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        iswificonnected = true;
        isInternetOn = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    GetConnect(); // calls getconnect method to check which type if connection it
  }
}
