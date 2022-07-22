import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/shared_widget/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/my_api.dart';
import '../shared_widget/Gender.dart';

class EditProfile extends StatefulWidget {
  EditProfile({
    Key? key,
  }) : super(key: key);
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var therapist;
  var msg = '';
  var emailController = TextEditingController();
  bool _isSaving = false;
  var firstnameController = TextEditingController();
  var lastnameController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    getTherapistInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: therapist != null
            ? SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage("assets/images/therapist.png"),
                        width: 140,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: firstnameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: therapist['f_name'],
                          prefixIcon: Icon(
                            Icons.person,
                            color: primaryColor,
                          ),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: lastnameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: therapist['l_name'],
                          prefixIcon: Icon(
                            Icons.person,
                            color: primaryColor,
                          ),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: therapist['email'],
                          prefixIcon: Icon(
                            Icons.email,
                            color: primaryColor,
                          ),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: therapist['phone'],
                          prefixIcon: Icon(
                            Icons.phone,
                            color: primaryColor,
                          ),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _editProfile();
                        },
                        child: Text(
                          _isSaving ? 'Saving...' : 'Save',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFF001E6C)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 106, vertical: 10)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27))),
                        ),
                      ),
                      Text(msg != null ? msg : ''),
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void getTherapistInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
    };

    var res = await CallApi().postData(data, 'therapist/getTherapist');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(() {
        therapist = body;
      });
      print(therapist);
    } else {
      setState(() {
        msg = body['message'];
      });
    }
  }

  void _editProfile() async {
    setState(() {
      _isSaving = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    if (firstnameController.text == '') {
      setState(() {
        firstnameController.text = therapist['f_name'];
      });
    }
    if (lastnameController.text == '') {
      setState(() {
        lastnameController.text = therapist['l_name'];
      });
    }
    if (emailController.text == '') {
      setState(() {
        emailController.text = therapist['email'];
      });
    }
    if (phoneController.text == '') {
      setState(() {
        phoneController.text = therapist['phone'];
      });
    }
    var data = {
      "f_name": firstnameController.text,
      "l_name": lastnameController.text,
      "gender": 'female',
      // "password": password,
      "email": emailController.text,
      "birthdate": '2000-02-22',
      "phone": phoneController.text,
      "token": token,
    };

    var res = await CallApi().postData(data, 'therapist/editTherpistProfile');
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        msg = body['message'];
      });
    } else {
      setState(() {
        msg = body['message'];
      });
    }

    setState(() {
      _isSaving = false;
      print(therapist);
    });
  }
}
