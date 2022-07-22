import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/shared_widget/colors.dart';
import 'package:flutter_project/shared_widget/components/components.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend/my_api.dart';

class Edit_prof extends StatefulWidget {
  const Edit_prof({Key? key}) : super(key: key);

  @override
  State<Edit_prof> createState() => _Edit_profState();
}

class _Edit_profState extends State<Edit_prof> {
  var patient;
  var msg = '';
  var emailController = TextEditingController();
  bool _isSaving = false;
  var passwordController = TextEditingController();
  var firstnameController = TextEditingController();
  var lastnameController = TextEditingController();
  var phoneController = TextEditingController();
  String name = 'rehab';
  var formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  var confirmpassController = TextEditingController();
  late File imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        shadowColor: Colors.white,
        elevation: 0.0,
        leading: BackButton(),
        title: defaultText(
            text: 'Edit Profile',
            fontSize: 20.0,
            textColor: Colors.white,
            isBold: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: patient != null
            ? SingleChildScrollView(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: <Widget>[
                            SizedBox(
                              height: 115,
                              width: 115,
                              child: CircleAvatar(
                                radius: 80.0,
                                backgroundImage:
                                    AssetImage('assets/images/patient.png'),
                              ),
                            ),
                            Positioned(
                                bottom: 12.0,
                                right: 15.0,
                                child: InkWell(
                                  onTap: () {
                                    _showchoice(context);
                                  },
                                  child: Icon(Icons.camera_alt,
                                      color: Colors.white, size: 28.0),
                                ))
                          ],
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: firstnameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: patient['f_name'],
                            prefixIcon: Icon(Icons.person, color: primaryColor),
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
                            hintText: patient['l_name'],
                            prefixIcon: Icon(Icons.person, color: primaryColor),
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: patient['email'],
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
                            hintText: patient['phone'],
                            prefixIcon: Icon(
                              Icons.phone,
                              color: primaryColor,
                            ),
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (!EmailValidator.validate(
                                emailController.text)) {
                              setState(() {
                                msg = 'Email not valid';
                              });
                            } else {
                              _editProfile();
                            }
                          },
                          child: defaultText(
                            text: _isSaving ? 'Saving...' : 'Save',
                            fontSize: 18,
                            textColor: Colors.white,
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(primaryColor),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 106, vertical: 10)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27))),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        defaultText(
                            text: msg != null ? msg : '',
                            fontSize: 16,
                            textColor: Colors.red),
                      ],
                    ),
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
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
      print(patient);
    } else {
      print(body['message']);
    }
  }

  void initState() {
    getPatientInfo();
    super.initState();
  }

  void _editProfile() async {
    setState(() {
      _isSaving = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (firstnameController.text == '') {
      setState(() {
        firstnameController.text = patient['f_name'];
      });
    }
    if (lastnameController.text == '') {
      setState(() {
        lastnameController.text = patient['l_name'];
      });
    }
    if (emailController.text == '') {
      setState(() {
        emailController.text = patient['email'];
      });
    }
    if (phoneController.text == '') {
      setState(() {
        phoneController.text = patient['phone'];
      });
    }
    var data = {
      "f_name": firstnameController.text,
      "l_name": lastnameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "token": token,
    };

    var res = await CallApi().postData(data, 'patient/editPatientProfile');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode == 200) {
      setState(() {
        msg = body['message'];
      });
    } else {
      setState(() {
        msg = body['errors'][0];
      });
    }

    setState(() {
      _isSaving = false;
    });
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openGallary(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showchoice(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Make a choice!',
              style: TextStyle(color: Color(0xFF001E6C)),
            ),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text(
                    'Gallary',
                    style: TextStyle(color: Color(0xFF001E6C)),
                  ),
                  onTap: () {
                    _openGallary(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text(
                    'Camera',
                    style: TextStyle(color: Color(0xFF001E6C)),
                  ),
                  onTap: () {
                    _openCamera(context);
                  },
                )
              ],
            )),
          );
        });
  }
}
