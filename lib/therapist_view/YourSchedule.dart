import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/shared_widget/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../backend/my_api.dart';
import '../models/appiontments.dart';
import '../models/patientSessions.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  late Future<List<Appiontments>> appiont;
  late List<Appiontments> appiontList = [];

  late Future<List<sessions>> upcoming;
  late List<sessions> upcominglist = [];
  late Future<List<sessions>> history;
  late List<sessions> historylist = [];

  var size, height, width;

  @override
  void initState() {
    super.initState();
    appiont = getScheduale();
    history = getHistorySession();
    upcoming = getTodaySession();
    convertAppiont(appiont);
    convertHistory(history);
    convertUpcoming(upcoming);
  }

  void convertAppiont(appiont) async {
    appiontList = await appiont;
  }

  void convertHistory(history) async {
    historylist = await history;
  }

  void convertUpcoming(upcoming) async {
    upcominglist = await upcoming;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
        body: appiontList.isNotEmpty ||
                upcominglist.isNotEmpty ||
                historylist.isNotEmpty
            ? SfCalendar(
                view: CalendarView.week,
                showNavigationArrow: true,
                showDatePickerButton: true,
                showWeekNumber: true,
                allowViewNavigation: true,
                dataSource: MeetingDataSource(
                    getAppointments(appiontList, upcominglist, historylist)))
            : SfCalendar(
                view: CalendarView.week,
                showNavigationArrow: true,
                showDatePickerButton: true,
                showWeekNumber: true,
                allowViewNavigation: true,
              ));
  }
}

List<dynamic> getAppointments(List<Appiontments> appiont,
    List<sessions> upcoming, List<sessions> history) {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  var startTime;
  var endTime;

  for (var i = 0; i < appiont.length; i++) {
    startTime = appiont[i].date + ' ' + appiont[i].startTime;
    startTime = DateTime.parse(startTime);
    endTime = appiont[i].date + ' ' + appiont[i].endTime;
    endTime = DateTime.parse(endTime);
    meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Available',
      color: Color.fromARGB(255, 15, 169, 46),
    ));
  }
  for (var i = 0; i < history.length; i++) {
    startTime = history[i].date + ' ' + history[i].startTime;
    startTime = DateTime.parse(startTime);
    endTime = history[i].date + ' ' + history[i].endTime;
    endTime = DateTime.parse(endTime);
    meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: history[i].therapistFname! + ' ' + history[i].therapistLname!,
      color: Colors.grey,
    ));
  }
  for (var i = 0; i < upcoming.length; i++) {
    startTime = upcoming[i].date + ' ' + upcoming[i].startTime;
    startTime = DateTime.parse(startTime);
    endTime = upcoming[i].date + ' ' + upcoming[i].endTime;
    endTime = DateTime.parse(endTime);
    meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: upcoming[i].therapistFname! + ' ' + upcoming[i].therapistLname!,
      color: secondaryColor,
    ));
  }
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<dynamic> source) {
    appointments = source;
  }
}

Future<List<sessions>> getTodaySession() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var token = localStorage.getString('token');
  var data = {
    "token": token,
  };

  List<sessions> sess = [];

  var res = await CallApi().postData(data, 'session/TherapistTodaySession');
  var body = json.decode(res.body);
  print(body);
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

Future<List<sessions>> getHistorySession() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var token = localStorage.getString('token');
//  print(token);

  var data = {
    "token": token,
  };
  List<sessions> sess = [];

  var res = await CallApi().postData(data, 'session/TherapistHistorySession');
  var body = json.decode(res.body);
  //print(body);
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

Future<List<Appiontments>> getScheduale() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var token = localStorage.getString('token');
  var data = {
    "token": token,
  };

  var res = await CallApi().postData(data, 'appiontment/getSchedual');
  var body = json.decode(res.body);
  List<Appiontments> appiont = [];

  if (res.statusCode == 200) {
    for (var u in body) {
      Appiontments appiontment = Appiontments(
          date: u['date'], startTime: u['startTime'], endTime: u['endTime']);
      appiont.add(appiontment);
    }
    return appiont;
  } else {
    return appiont;
  }
}
