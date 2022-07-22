import 'dart:convert';
import 'package:flutter/material.dart';
import '../meeting_screen.dart';
import '../shared_widget/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/my_api.dart';
import '../models/patientSessions.dart';
import '../shared_widget/components/components.dart';
import '../therapist_view/searchScreen.dart';

class MySession extends StatefulWidget {
  MySession({Key? key}) : super(key: key);

  @override
  State<MySession> createState() => _MySessionState();
}

class _MySessionState extends State<MySession> {
  late Future<List<sessions>> listSession;
  var size, height, width;
  var session;
  var msgSession = '';
  var msgCancel = '';
  var start;
  var now;
  var leftTime;
  var diffInMin, diffInHour;
  var patient;
  @override
  void initState() {
    super.initState();
    listSession = getHistorySession();
    getTodaySession();
    getPatientInfo();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: width,
                height: height / 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey[300],
                ),
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.search)),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      'Search',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                width: 380,
                height: height / 18,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: Row(children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  //put it in center
                  defaultText(
                    text: 'Next Session',
                    textColor: Colors.white,
                    isBold: true,
                    fontSize: 20.0,
                  ),
                ]),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                width: 380.0,
                height: session != null ? height / 3.2 : height / 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(0),
                    topLeft: Radius.circular(0),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: primaryColor,
                    style: BorderStyle.solid,
                  ),
                ),
                child: session != null
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Therapist : " +
                                    session['f_name'] +
                                    '  ' +
                                    session['l_name'],
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: height / 100,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(
                                            Icons.access_time,
                                            size: 40.0,
                                            color: primaryColor,
                                          ),
                                          onPressed: () {}),
                                      SizedBox(
                                        width: width / 70,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: height / 100,
                                          ),
                                          defaultText(
                                              text: "Start Time " +
                                                  session['startTime'],
                                              fontSize: 15.0,
                                              textColor: primaryColor),
                                        ],
                                      ),
                                      SizedBox(
                                        width: width / 7,
                                      ),
                                      Container(
                                        height: height / 20,
                                        child: MaterialButton(
                                          onPressed: () {
                                            diffInMin == 1
                                                ? joinMeeting(
                                                    context,
                                                    session['meeting_id'],
                                                    session['meeting_password'],
                                                    patient['f_name'])
                                                : null;
                                          },
                                          child: Text(
                                            'Join',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(70.0),
                                          color: diffInMin == 1
                                              ? primaryColor
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height / 100,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(
                                            Icons.access_time,
                                            size: 40.0,
                                            color: primaryColor,
                                          ),
                                          onPressed: () {}),
                                      SizedBox(
                                        width: width / 80,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: height / 100,
                                          ),
                                          defaultText(
                                              text: "End Time " +
                                                  session['endTime'],
                                              fontSize: 15.0,
                                              textColor: primaryColor),
                                        ],
                                      ),
                                      SizedBox(
                                        width: width / 6,
                                      ),
                                      Container(
                                        height: height / 20,
                                        child: MaterialButton(
                                          onPressed: () {
                                            // diffInHour > 24?
                                            cancelSession(
                                                session['session_id']);
                                            //    : null;
                                          },
                                          child: Text(
                                            'Cancel',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(70.0),
                                          color: diffInHour > 24
                                              ? primaryColor
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height / 100,
                                  ),
                                  Text(
                                    'Your session will start after ${diffInHour} hours',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height / 100,
                                  ),
                                ],
                              ),
                            ]),
                      )
                    : msgSession != null
                        ? Center(
                            child: Text(
                              msgSession,
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        : Text(''),
              ),
              SizedBox(
                height: 10.0,
              ),
              defaultText(
                  text: msgCancel != null ? msgCancel : '',
                  fontSize: 15,
                  isBold: true),
              SizedBox(
                height: 10.0,
              ),
              defaultText(
                  text: "History",
                  fontSize: 20.0,
                  textColor: primaryColor,
                  isBold: true),
              Container(
                height: height,
                child: FutureBuilder<List<sessions>>(
                    future: listSession,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.length != 0
                            ? ListView.builder(itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    SizedBox(
                                      height: height / 100,
                                    ),
                                    Container(
                                      height: height,
                                      child: ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) =>
                                            buildPatientItem(
                                                snapshot.data![index]
                                                    .therapistFname,
                                                snapshot.data![index]
                                                    .therapistLname,
                                                snapshot.data![index].startTime,
                                                snapshot.data![index].endTime,
                                                snapshot.data![index].date,
                                                context),
                                      ),
                                    ),
                                  ],
                                );
                              })
                            : defaultText(
                                text: "No History Sessions", fontSize: 15);
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void cancelSession(session_id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {"token": token, "session_id": session_id};
    var res = await CallApi().postData(data, 'session/PTCancelSession');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(() {
        msgCancel = body['message'];
      });
    } else {
      setState(() {
        msgCancel = body['message'];
      });
    }
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

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  void getTodaySession() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
    };

    var res = await CallApi().postData(data, 'session/PatientTodaySession');
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        session = body;
        start = session['date'] + ' ' + session['startTime'];
        DateTime StartDate = DateTime.parse(start);
        DateTime now = DateTime.now();
        //  diffInHour = _printDuration(StartDate.difference(now));

        diffInMin = StartDate.difference(now).inMinutes;
        diffInHour = StartDate.difference(now).inHours;
        print(diffInHour);
        print(diffInMin);
      });
    } else {
      msgSession = body['message'];
    }
  }

  Future<List<sessions>> getHistorySession() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
    };

    var res = await CallApi().postData(data, 'session/PatientHistorySession');
    var body = json.decode(res.body);
    List<sessions> sess = [];
    if (res.statusCode == 200) {
      for (var u in body) {
        sessions p = sessions(
            date: u['date'],
            startTime: u['startTime'],
            endTime: u['endTime'],
            state: u['state'],
            therapistFname: u['f_name'],
            therapistLname: u['l_name']);
        sess.add(p);
      }

      return sess;
    } else {
      return sess;
    }
  }

  Widget buildPatientItem(var f_name, var l_name, var startTime, var endTime,
          var date, BuildContext context) =>
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 400,
          height: 180.0,
          child: Padding(
            padding: const EdgeInsets.all(23.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                defaultText(
                  text: 'Therapist: ' + f_name + ' ' + l_name,
                  isBold: true,
                  fontSize: 20.0,
                  textColor: primaryColor,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        defaultText(
                          text: 'Session date: ' + date,
                          isBold: true,
                          fontSize: 17.0,
                          textColor: primaryColor,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        defaultText(
                          text: 'Start time: ' + startTime,
                          isBold: true,
                          fontSize: 17.0,
                          textColor: primaryColor,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        defaultText(
                          text: 'End time: ' + endTime,
                          isBold: true,
                          fontSize: 17.0,
                          textColor: primaryColor,
                        ),
                      ],
                    ),
                    SizedBox(width: width / 35),
                    Container(
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundImage:
                            AssetImage('assets/images/therapist.png'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              25.0,
            ),
            border: Border.all(
                color: primaryColor, width: 2.0, style: BorderStyle.solid),
          ),
        ),
      );
}
