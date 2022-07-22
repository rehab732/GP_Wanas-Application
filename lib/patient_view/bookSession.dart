import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/models/appiontments.dart';
import 'package:flutter_project/shared_widget/colors.dart';
import 'package:flutter_project/shared_widget/components/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend/my_api.dart';

class bookSession extends StatefulWidget {
  var therapist_id, f_name, l_name, image;
  bookSession({
    Key? key,
    required this.therapist_id,
    required this.f_name,
    required this.l_name,
    required this.image,
  }) : super(key: key);
  @override
  bookSessionState createState() => bookSessionState(
      therapist_id: this.therapist_id,
      f_name: this.f_name,
      l_name: this.l_name,
      image: this.image);
}

class bookSessionState extends State<bookSession> {
  int currentStep = 0;
  String _selectedApp = '';
  var size, height, width;
  var msgSession;
  final int therapist_id;
  int select_app_id = 0;
  String f_name, l_name, image;
  late Future<List<Appiontments>> appiontments;
  DateTime datetime = DateTime(0, 0, 0, 0, 0);

  var msg;
  bookSessionState(
      {required this.therapist_id,
      required this.f_name,
      required this.l_name,
      required this.image});

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      appBar: AppBar(
        title: defaultText(
            text: 'Wanas',
            fontSize: 20.0,
            isBold: true,
            textColor: Colors.white),
        backgroundColor: primaryColor,
      ),
      body: Theme(
        data: ThemeData(
            colorScheme: const ColorScheme.light(primary: primaryColor)),
        child: Stepper(
          type: StepperType.horizontal,
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: currentStep < getSteps().length - 1
              ? continued
              : GetFinalState() == StepState.error
                  ? GetErrorMsg()
                  : finalStep,
          onStepCancel: cancel,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    appiontments = therapistAppiontment();
  }

  List<Step> getSteps() => [
        Step(
            state: GetAppiontmentState(),
            isActive: currentStep >= 0,
            title:
                defaultText(text: 'Appiontment', fontSize: 15.0, isBold: true),
            content: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Text('Dr.' + f_name + ' ' + l_name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: primaryColor)),
                const SizedBox(height: 20),
                Image(
                  image: AssetImage("assets/images/therapist.png"),
                  width: 100,
                  height: 60,
                ),
                Container(
                  child: FutureBuilder<List<Appiontments>>(
                      future: appiontments,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data!.length != 0
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                        shape: BeveledRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                              snapshot.data![index].date +
                                                  ' ' +
                                                  snapshot
                                                      .data![index].startTime +
                                                  '-' +
                                                  snapshot.data![index].endTime,
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 20)),
                                          leading: Radio<String>(
                                            value: snapshot.data![index].date +
                                                ' ' +
                                                snapshot
                                                    .data![index].startTime +
                                                '-' +
                                                snapshot.data![index].endTime,
                                            groupValue: _selectedApp,
                                            onChanged: (value) => {
                                              setState(() {
                                                _selectedApp = value!;
                                                select_app_id =
                                                    snapshot.data![index].id!;
                                                print(select_app_id);
                                              })
                                            },
                                          ),
                                        ));
                                  })
                              : Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text("No Available Appiontments"),
                                );
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                ),
              ],
            )),
        Step(
            state: StepState.complete,
            isActive: currentStep >= 1,
            title: defaultText(text: 'Confirm', fontSize: 15.0, isBold: true),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  width: 2,
                  color: primaryColor,
                  style: BorderStyle.solid,
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    defaultText(
                        text: "Dr." + f_name + ' ' + l_name,
                        fontSize: 24,
                        isBold: true),
                    const SizedBox(height: 20),
                    defaultText(
                      text: '$_selectedApp',
                      isBold: true,
                      fontSize: 18,
                    ),
                    const SizedBox(height: 10),
                    defaultText(
                        text: msgSession != null ? msgSession : '',
                        fontSize: 17.0,
                        textColor: Colors.red),
                  ],
                ),
              ),
            )),
      ];
  //return back one step ..
  cancel() {
    setState(() {
      msg = '';
    });

    currentStep > 0 ? setState(() => currentStep -= 1) : null;
  }

//containue to second step ..
  continued() {
    currentStep < getSteps().length ? setState(() => currentStep += 1) : null;
  }

  //call register function ..
  finalStep() {
    BookSesion();
  }

  GetAppiontmentState() {
    if (select_app_id != 0 && currentStep != 0) {
      return StepState.complete;
    } else if (currentStep == 0) {
      return StepState.editing;
    } else {
      return StepState.error;
    }
  }

  GetErrorMsg() {
    setState(() {
      msg = 'Please fill all fields';
    });
  }

  GetFinalState() {
    if (currentStep < getSteps().length) {
      return StepState.indexed;
    }
    if (select_app_id != 0) {
      return StepState.complete;
    } else {
      return StepState.error;
    }
  }

  void BookSesion() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
      "therapist_id": therapist_id,
      "appiontment_id": select_app_id
    };
    var res = await CallApi().postData(data, 'session/bookSession');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      msgSession = body['message'];
    } else {
      msgSession = body['message'];
    }
    print(msgSession);
  }

  Future<List<Appiontments>> therapistAppiontment() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {"token": token, "therapist_id": therapist_id};
    print(therapist_id);
    List<Appiontments> appiont = [];

    var res = await CallApi().postData(data, 'patient/TherapistAppiontments');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode == 200) {
      for (var u in body) {
        Appiontments user = Appiontments(
          id: int.parse(u['id']),
          therapist_id: int.parse(u['therapist_id']),
          date: u['date'],
          endTime: u['endTime'],
          startTime: u['startTime'],
        );
        appiont.add(user);
      }
      return appiont;
    } else {
      return appiont;
    }
  }
}
