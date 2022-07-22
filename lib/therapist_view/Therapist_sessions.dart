import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project/meeting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/my_api.dart';
import '../shared_widget/colors.dart';
import '../shared_widget/components/components.dart';

class sessions extends StatefulWidget {
  @override
  State<sessions> createState() => _sessionsState();
}

class _sessionsState extends State<sessions> {
  var session;
  var msgSession;
  var start;
  var now;
  var leftTime;
  var diffInMin, diffInHour;
  var patient;
  var size, height, width;
  @override
  void initState() {
    getTodaySession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    var msgSession;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                width: 380,
                height: height / 16,
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
                width: 380,
                height: session != null ? height / 2.7 : height / 3,
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
                                            size: 30.0,
                                            color: primaryColor,
                                          ),
                                          onPressed: () {}),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: height / 100,
                                          ),
                                          defaultText(
                                            text: "Start Time \n" +
                                                session['startTime'],
                                            fontSize: 15.0,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: width / 6,
                                      ),
                                      Container(
                                        height: height / 20,
                                        child: MaterialButton(
                                          onPressed: () {
                                            diffInMin < 5
                                                ? startMeetingNormal(context,
                                                    session['meeting_id'])
                                                : null;
                                          },
                                          child: Text(
                                            'Start',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(70.0),
                                          color: diffInMin < 5
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
                                            size: 30.0,
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
                                            text: "End Time \n" +
                                                session['endTime'],
                                            fontSize: 15.0,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: width / 6,
                                      ),
                                      Container(
                                        height: height / 20,
                                        child: MaterialButton(
                                          onPressed: () {
                                            diffInHour > 24
                                                ? cancelSession(
                                                    session['session_id'])
                                                : null;
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
                                  defaultText(
                                    text: diffInHour != null
                                        ? 'Your session will start after $diffInHour Hours'
                                        : '',
                                    isBold: true,
                                    fontSize: 17.0,
                                  ),
                                  SizedBox(
                                    height: height / 100,
                                  ),
                                ],
                              ),
                            ]),
                      )
                    : Center(
                        child: defaultText(
                            text:
                                msgSession != null ? msgSession : 'No Sessions',
                            fontSize: 20,
                            textColor: primaryColor),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
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

    var res =
        await CallApi().postData(data, 'session/TherapistUpcomingSession');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(() {
        session = body;

        start = session['date'] + ' ' + session['startTime'];
        DateTime StartDate = DateTime.parse(start);
        DateTime now = DateTime.now();
        diffInHour = StartDate.difference(now).inHours;

        // diffInHour = _printDuration(StartDate.difference(now));
        diffInMin = StartDate.difference(now).inMinutes;
      });
    } else {
      setState(() {
        msgSession = body['message'];
      });
    }
  }

  void cancelSession(session_id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {"token": token, "session_id": session_id};
    var res = await CallApi().postData(data, 'session/ThCancelSession');
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        msgSession = body['message'];
      });
    } else {
      setState(() {
        msgSession = body['message'];
      });
    }
  }
}
