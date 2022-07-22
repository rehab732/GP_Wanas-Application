// @dart=2.12
import 'dart:convert';
import 'package:flutter/material.dart';
import '../shared_widget/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/my_api.dart';
import '../shared_widget/components/components.dart';
import 'mood.dart';
import 'mood_chart.dart';

class patientHome extends StatefulWidget {
  @override
  State<patientHome> createState() => _patientHomeState();
}

class _patientHomeState extends State<patientHome> {
  var size, height, width;
  var patient;
  var session;
  var msgSession = '';

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return patient != null
        ? SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: height,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: height / 60,
                    ),
                    defaultText(
                      text: "Good Morning: " + patient['f_name'],
                      fontSize: 23,
                      isBold: true,
                    ),
                    MoodChart(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: 340.0,
                      padding: const EdgeInsets.all(10.0),
                      height: height / 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xFF385DA6),
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10.0,
                            ),
                            Icon(
                              Icons.mood_rounded,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            SizedBox(
                              width: width / 90,
                            ),
                            TextButton(
                              style: ButtonStyle(
                                  // foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                  ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecordMood(),
                                  ),
                                );
                              },
                              child: Text(
                                'Enter your mood',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width / 6,
                            ),
                            Icon(
                              Icons.arrow_right,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height / 7),
                    SizedBox(
                      height: session == null ? height / 40 : 1,
                    ),
                  ],
                ),
              ),
            ),
          )
        : Center(child: const CircularProgressIndicator());
  }

  void getPatientInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
    };

    var res = await CallApi().postData(data, 'patient/getPatient');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(() {
        patient = body;
      });
      
    } else {
      print(body['message']);
    }
  }

  @override
  void initState() {
    super.initState();
    //get patient info ..
    getPatientInfo();
  }
}
