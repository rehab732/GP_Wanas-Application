// @dart=2.12

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/shared_widget/components/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend/my_api.dart';
import '../loging/signUp.dart';
import '../patient_view/patientBar.dart';
import '../shared_pages/ResetPassword.dart';
import '../therapist_view/therapistBar.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var message = "";
  bool _isLoading = false;
  bool _isObscure = true;
  var size, height, width;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    Validation() {
      if (formKey.currentState!.validate()) {
        if (EmailValidator.validate(emailController.text)) {
          _login(context);
        } else {
          setState(() {
            message = 'Email not Valid';
          });
        }
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: height / 15,
                ),
                defaultText(
                  text: 'Wanas',
                  fontSize: 45.0,
                  isBold: true,
                ),
                const Image(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: height / 45,
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email field cant be empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: TextStyle(color: Colors.black),
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color(0xFF385DA6),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 45,
                ),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password field cant be empty';
                    }
                    return null;
                  },
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: const UnderlineInputBorder(),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xFF385DA6),
                      ),
                      suffixIcon: IconButton(
                          color: Color(0xFF385DA6),
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          })),
                ),
                SizedBox(
                  height: height / 35,
                ),
                ElevatedButton(
                  onPressed: () {
                    Validation();
                  },
                  child: defaultText(
                      text: !_isLoading ? "LOGIN" : "Logining ..",
                      fontSize: 20,
                      textColor: Colors.white,
                      isBold: true),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF385DA6)),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                        horizontal: width / 4, vertical: height / 50)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27))),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: height / 25),
                  child: defaultText(
                    text: message,
                    fontSize: 15,
                    textColor: Colors.red,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(7),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResetPassword(),
                          ),
                        );
                      },
                      child: defaultText(
                        text: " Forgot Password ?",
                        isBold: true,
                        fontSize: 15.0,
                      ),
                    )),
                SizedBox(height: height / 120),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an accout? "),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ),
                          );
                        },
                        child: defaultText(
                          text: " SIGNUP",
                          isBold: true,
                          fontSize: 15.0,
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//login function ..
  void _login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      "email": emailController.text,
      "password": passwordController.text
    };

    var res = await CallApi().postData(data, 'login');
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      var tokenssss = await FirebaseMessaging.instance.getToken();
      Map<String, dynamic> data = {
        "token": await FirebaseMessaging.instance.getToken(),
      };
      print(body['id']);

      if (body['type'] == "0") {
        FirebaseFirestore.instance
            .collection("patient")
            .doc(body["id"].toString())
            .set(data);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PatientBar(title: 'Wanas'),
          ),
        );
      } else if (body['type'] == "1") {
        FirebaseFirestore.instance
            .collection("therapist")
            .doc(body['id'].toString())
            .set(data);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const therapistBar(title: 'Wanas'),
          ),
        );
      } else {
        print("string value type");
      }
    } else {
      setState(() {
        message = body['message'];
      });
    }
    setState(() {
      _isLoading = false;
    });
  }
}
