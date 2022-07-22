// @dart=2.12
import 'dart:convert';
import 'package:flutter/material.dart';
import '../shared_widget/components/components.dart';
import '../models/patientSessions.dart';
import '../shared_widget/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/my_api.dart';

class viewPatientDetails extends StatefulWidget {
  int id;
  viewPatientDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<viewPatientDetails> createState() =>
      _viewPatientDetailsState(id: this.id);
}

class _viewPatientDetailsState extends State<viewPatientDetails> {
  late Future<List<sessions>> session;
  var patient;
  final int id;
  var diagnoseController = TextEditingController();

  _viewPatientDetailsState({required this.id});

  @override
  void initState() {
    super.initState();
    PatientDetails();
    session = patient_Sessions();
  }

  var size, height, width;
  var msg;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: defaultText(
            text: 'Patient Details',
            fontSize: 20.0,
            textColor: Colors.white,
            isBold: true),
        backgroundColor: primaryColor,
        leading: BackButton(),
        elevation: 0,
      ),
      body: patient != null
          ? ListView(
              children: [
                Container(
                  width: double.infinity,
                  height: 180.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/patient.png')),
                    shape: BoxShape.circle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(patient['f_name'] + ' ' + patient['l_name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: primaryColor)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: diagnoseController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          labelText: 'Diagnosis',
                          labelStyle: TextStyle(
                              color: primaryColor,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: Column(
                          children: [
                            defaultButton(
                                width: 100,
                                function: () {
                                  saveDiagnose();
                                },
                                text: 'save'),
                            SizedBox(height: 5.0),
                            Divider(
                              color: primaryColor,
                              thickness: 1.0,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      defaultText(
                        text: 'History Sessions',
                        isBold: true,
                        fontSize: 24,
                      ),
                      FutureBuilder<List<sessions>>(
                          future: session,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data!.length != 0
                                  ? ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    width: 1,
                                                    color: primaryColor,
                                                    style: BorderStyle.solid,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                              icon: Icon(
                                                                Icons
                                                                    .date_range_outlined,
                                                                size: 40.0,
                                                                color:
                                                                    primaryColor,
                                                              ),
                                                              onPressed: () {}),
                                                          SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          defaultText(
                                                              text: "Date:  ",
                                                              fontSize: 22.0,
                                                              isBold: true),
                                                          defaultText(
                                                            text: snapshot
                                                                .data![index]
                                                                .date,
                                                            fontSize: 20.0,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                              icon: Icon(
                                                                Icons
                                                                    .access_time,
                                                                size: 40.0,
                                                                color:
                                                                    primaryColor,
                                                              ),
                                                              onPressed: () {}),
                                                          SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          defaultText(
                                                              text:
                                                                  "Start Time:  ",
                                                              fontSize: 22.0,
                                                              isBold: true),
                                                          defaultText(
                                                            text: snapshot
                                                                .data![index]
                                                                .startTime,
                                                            fontSize: 20.0,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                              icon: Icon(
                                                                Icons
                                                                    .access_time,
                                                                size: 40.0,
                                                                color:
                                                                    primaryColor,
                                                              ),
                                                              onPressed: () {}),
                                                          SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          defaultText(
                                                              text:
                                                                  "End Time:  ",
                                                              fontSize: 22.0,
                                                              isBold: true),
                                                          defaultText(
                                                            text: snapshot
                                                                .data![index]
                                                                .endTime,
                                                            fontSize: 20.0,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                              icon: Icon(
                                                                Icons.ac_unit,
                                                                size: 40.0,
                                                                color:
                                                                    primaryColor,
                                                              ),
                                                              onPressed: () {}),
                                                          SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          defaultText(
                                                              text: "State:  ",
                                                              fontSize: 22.0,
                                                              isBold: true),
                                                          defaultText(
                                                            text: snapshot
                                                                .data![index]
                                                                .state,
                                                            fontSize: 20.0,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        );
                                      })
                                  : defaultText(
                                      text: 'No History Session !',
                                      fontSize: 15);
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                    ],
                  ),
                ),
              ],
            )
          : Center(child: const CircularProgressIndicator()),
    );
  }

  Future<void> saveDiagnose() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
      "patient_id": id,
      "diagnose": diagnoseController,
    };

    var res = await CallApi().postData(data, 'therapist/writeDiagnose');
    var body = json.decode(res.body);

    setState(() {
      msg = body['message'];
    });
  }

  Future<List<sessions>> patient_Sessions() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
      "patient_id": id,
    };

    var res =
        await CallApi().postData(data, 'therapist/viewSessionPatientDetails');
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      List<sessions> session = [];
      for (var u in body) {
        sessions p = sessions(
          date: u['date'],
          startTime: u['startTime'],
          endTime: u['endTime'],
          state: u['state'],
        );
        session.add(p);
      }
      return session;
    } else {
      return session;
    }
  }

  void PatientDetails() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
      "patient_id": id,
    };

    var res = await CallApi().postData(data, 'therapist/viewPatientDetails');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(() {
        patient = body;
        diagnoseController = patient['diagnose'];
      });
    } else {
      print(body['message']);
    }
  }
}
