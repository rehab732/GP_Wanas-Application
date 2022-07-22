import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/patientModel.dart';
import '../therapist_view/viewPatientDetails.dart';
import '../shared_widget/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/my_api.dart';
import '../therapist_view/searchScreen.dart';
import '../therapist_view/viewPatientDetails.dart';
import '../loging/Login.dart';
import '../shared_widget/components/components.dart';

class YourPatients extends StatefulWidget {
  const YourPatients({Key? key}) : super(key: key);

  @override
  State<YourPatients> createState() => _YourPatientsState();
}

class _YourPatientsState extends State<YourPatients> {
  late Future<List<Patient>> patients;
  var msg = '';
  var size, height, width;

  @override
  void initState() {
    super.initState();
    patients = getPatients();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Patient>>(
            future: patients,
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
                                        snapshot.data![index].f_name,
                                        snapshot.data![index].l_name,
                                        snapshot.data![index].diagnose,
                                        snapshot.data![index].id,
                                        context),
                              ),
                            ),
                          ],
                        );
                      })
                    : defaultText(text: "No available patients", fontSize: 15);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Future<List<Patient>> getPatients() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
    };
    List<Patient> patient = [];

    var res = await CallApi().postData(data, 'therapist/getPatients');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode == 200) {
      for (var u in body) {
        Patient p = Patient(
            f_name: u['f_name'],
            l_name: u['l_name'],
            diagnose: u['diagnose'],
            id: int.parse(u['patient_id']),
            email: u['email'],
            phone: u['phone']);
        patient.add(p);
      }

      return patient;
    } else {
      return patient;
    }
  }

  Widget buildPatientItem(
          var fname, var lname, var diagnosis, var id, BuildContext context) =>
      Padding(
        padding: EdgeInsets.all(width / 20),
        child: Container(
          width: width,
          height: height / 2.5,
          child: Padding(
            padding: EdgeInsets.all(width / 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        defaultText(
                          text: "Patient: ",
                          isBold: true,
                          fontSize: 25.0,
                        ),
                        defaultText(
                          text: fname + ' ' + lname,
                          fontSize: 22.0,
                        ),
                        SizedBox(height: 10.0),
                        defaultText(
                          text: diagnosis != null
                              ? "Diagnose: "
                              : 'Not Diagnosed',
                          isBold: true,
                          fontSize: 25.0,
                        ),
                        defaultText(
                          text: diagnosis != null ? diagnosis : '',
                          fontSize: 22.0,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: width / 12,
                    ),
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: AssetImage('assets/images/patient.png'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: width / 2.5,
                  height: height / 15,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => viewPatientDetails(
                            id: id,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'View details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70.0),
                    color: primaryColor,
                  ),
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
