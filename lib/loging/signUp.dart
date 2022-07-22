import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/backend/my_api.dart';
import 'package:flutter_project/patient_view/patientBar.dart';
import 'package:flutter_project/shared_widget/colors.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../patient_view/PatientHome.dart';
import '../shared_widget/components/components.dart';
import 'Login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var size, height, width;

  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;
  bool _isObscurePass = true;
  bool _isObscureConfirm = true;
  var x;
  var firstnameController = TextEditingController();
  var lastnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmpassController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var phoneController = TextEditingController();
  var genderController = TextEditingController();
  var birthdateController = TextEditingController();
  TextEditingController datee = TextEditingController();
  bool _isLoading = false;
  var msg = '';

  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    // final isLastStep = _currentStep == 3;

    List<Step> stepList() => [
          Step(
            title: defaultText(
              text: 'Personal Info',
              fontSize: 9,
              isBold: true,
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: firstnameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(
                            color: Color(0xFF385DA6),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        labelText: 'First Name',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0xFF385DA6),
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide(
                              color: primaryColor,
                              //width: 5000.0,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: height / 30,
                    ),
                    TextFormField(
                      cursorColor: navbarColor,
                      controller: lastnameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(
                            color: Color(0xFF385DA6),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        labelText: 'Last Name',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0xFF385DA6),
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide(
                              color: Color(0xFF385DA6),
                              //width: 5000.0,
                            )),
                      ),
                    ),
                    SizedBox(height: height / 100),
                  ],
                ),
              ),
            ),
            isActive: _currentStep >= 0,
            state: GetPersonalstate(),
          ),
          Step(
              title: defaultText(text: 'Mobile', fontSize: 9, isBold: true),
              content: SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          labelText: 'Phone Number',
                          prefixIcon: Icon(
                            Icons.phone,
                            color: primaryColor,
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                              borderSide: BorderSide(
                                  width: 5.0, style: BorderStyle.solid)),
                        ),
                      ),
                      SizedBox(
                        height: height / 50,
                      ),
                      Container(
                        width: double.infinity,
                        height: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(40),
                          ),
                          border: Border.all(width: 1.0, color: Colors.grey),
                        ),
                        child: getWidget(false, true),
                      ),
                      SizedBox(height: height / 40),
                      TextFormField(
                        controller: datee,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                              color: Color(0xFF385DA6),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          labelText: 'Birthdate',
                          prefixIcon: const Icon(
                            Icons.calendar_month_rounded,
                            color: primaryColor,
                            size: 30,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: primaryColor,
                              size: 35,
                            ),
                            onPressed: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2023))
                                  .then((value) {
                                final dateFormat = DateFormat('yyyy-mm-dd');

                                final x = dateFormat.parse(value.toString());

                                final String formatted = dateFormat.format(x);
                                datee.text = formatted;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 45,
                      ),
                    ],
                  ),
                ),
              ),
              isActive: _currentStep >= 0,
              state: GetMobilstate()),
          Step(
            title: defaultText(text: 'Account', fontSize: 9, isBold: true),
            content: SingleChildScrollView(
              child: Form(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: TextStyle(
                            color: Color(0xFF385DA6),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0xFF385DA6),
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide(color: primaryColor)),
                      ),
                    ),
                    SizedBox(height: height / 30),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _isObscurePass,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                            color: Color(0xFF385DA6),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        labelText: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF385DA6),
                        ),
                        suffixIcon: IconButton(
                            color: const Color(0xFF385DA6),
                            icon: Icon(_isObscurePass
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscurePass = !_isObscurePass;
                              });
                            }),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide(color: primaryColor)),
                      ),
                    ),
                    SizedBox(height: height / 30),
                    TextFormField(
                      controller: confirmpassController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _isObscureConfirm,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                            color: Color(0xFF385DA6),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF385DA6),
                        ),
                        suffixIcon: IconButton(
                            color: const Color(0xFF385DA6),
                            icon: Icon(_isObscureConfirm
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscureConfirm = !_isObscureConfirm;
                              });
                            }),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide(color: primaryColor)),
                      ),
                    ),
                    SizedBox(height: height / 40),
                  ],
                ),
              ),
            ),
            isActive: _currentStep >= 0,
            state: GetAccountstate(),
          ),
          Step(
            state: GetFinalState(),
            isActive: _currentStep >= 0,
            title: defaultText(text: 'Confirm', fontSize: 9, isBold: true),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            defaultText(
                                text: 'First Name:',
                                fontSize: 15.0,
                                isBold: true),
                            const SizedBox(
                              width: 10,
                            ),
                            defaultText(
                              text: firstnameController.text,
                              fontSize: 15.0,
                              textColor: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            defaultText(
                                text: 'Last Name:',
                                fontSize: 15.0,
                                isBold: true),
                            const SizedBox(
                              width: 10,
                            ),
                            defaultText(
                              text: lastnameController.text,
                              fontSize: 15.0,
                              textColor: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            defaultText(
                                text: 'Email:', fontSize: 15.0, isBold: true),
                            const SizedBox(
                              width: 10,
                            ),
                            defaultText(
                              text: emailController.text,
                              fontSize: 15.0,
                              textColor: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            defaultText(
                                text: 'Gender:', fontSize: 15.0, isBold: true),
                            const SizedBox(
                              width: 10,
                            ),
                            defaultText(
                              text: x == 1 ? 'female' : 'male',
                              fontSize: 15.0,
                              textColor: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            defaultText(
                                text: 'Birthdate:',
                                fontSize: 15.0,
                                isBold: true),
                            const SizedBox(
                              width: 10,
                            ),
                            defaultText(
                              text: datee.text,
                              fontSize: 15.0,
                              textColor: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            defaultText(
                                text: 'Phone:', fontSize: 15.0, isBold: true),
                            const SizedBox(
                              width: 10,
                            ),
                            defaultText(
                              text: phoneController.text,
                              fontSize: 15.0,
                              textColor: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Colors.white,
                      border: Border.all(
                        width: 2,
                        color: const Color(0xFF385DA6),
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                ],
              ),
            ),
          ),
        ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        shadowColor: Colors.white,
        elevation: 5.0,
        title: defaultText(
            text: 'Sign Up',
            isBold: true,
            fontSize: 30.0,
            textColor: Colors.white),
        titleSpacing: 100.0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Theme(
                data: ThemeData(
                    colorScheme:
                        const ColorScheme.light(primary: Color(0xFF385DA6))
                ),
                child: Stepper(
                  elevation: 0,
                  type: stepperType,
                  physics: const ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  onStepContinue: _currentStep < 3
                      ? continued
                      : GetFinalState() == StepState.error
                          ? GetErrorMsg()
                          : finalStep,
                  onStepCancel: cancel,
                  steps: stepList(),
                ),
              ),
            ),
            // SizedBox(height: 40,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                defaultText(
                  text: msg,
                  fontSize: 15,
                  textColor: Colors.red,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                defaultText(
                    text: "Already have an accout? ",
                    fontSize: 15.0,
                    isBold: true,
                    textColor: Colors.grey),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    child: defaultText(
                        text: " Login ", isBold: true, fontSize: 20.0)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //return back one step ..
  cancel() {
    setState(() {
      msg = '';
    });

    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  //containue to second step ..
  continued() {
    _currentStep < 4 ? setState(() => _currentStep += 1) : null;
  }

  //call register function ..
  finalStep() {
    _register();
  }

  GetAccountstate() {
    if (passwordController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        confirmpassController.text.isNotEmpty &&
        _currentStep > 2) {
      if (passwordController.text.length < 6) {
        setState(() {
          msg = 'Password Must be at least 6 characters';
        });
        return StepState.disabled;
      } else if (passwordController.text != confirmpassController.text) {
        setState(() {
          msg = 'Password Dismatch ';
        });
        return StepState.disabled;
      } else if (!EmailValidator.validate(emailController.text)) {
        setState(() {
          msg = 'Email Must be Valid';
        });
        return StepState.disabled;
      } else {
        return StepState.complete;
      }
    } else if (_currentStep == 2) {
      return StepState.editing;
    } else if (_currentStep < 2) {
      return StepState.indexed;
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
    if (_currentStep < 4) {
      return StepState.indexed;
    }
    if (firstnameController.text.isNotEmpty &&
        lastnameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        confirmpassController.text.isNotEmpty) {
      return StepState.complete;
    } else {
      return StepState.error;
    }
  }

  GetMobilstate() {
    if (phoneController.text.isNotEmpty && _currentStep != 1) {
      if (phoneController.text.length < 11) {
        setState(() {
          msg = 'Please Enter Valid Phone number';
        });
      }
      return StepState.complete;
    } else if (_currentStep == 1) {
      return StepState.editing;
    } else if (_currentStep < 1) {
      return StepState.indexed;
    } else {
      return StepState.error;
    }
  }

  GetPersonalstate() {
    if (firstnameController.text.isNotEmpty &&
        lastnameController.text.isNotEmpty &&
        _currentStep != 0) {
      return StepState.complete;
    } else if (_currentStep == 0) {
      return StepState.editing;
    } else {
      return StepState.error;
    }
  }

  Widget getWidget(bool showOtherGender, bool alignVertical) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: GenderPickerWithImage(
        showOtherGender: false,
        selectedGender: Gender.Male,
        selectedGenderTextStyle: const TextStyle(
            color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20.0),
        unSelectedGenderTextStyle: const TextStyle(
            color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20.0),
        onChanged: (Gender? gender) {
          x = gender?.index;
        },
        maleImage: const AssetImage('assets/images/patient.png'),
        femaleImage: const AssetImage('assets/images/female.png'),
        equallyAligned: true,
        animationDuration: const Duration(milliseconds: 300),
        isCircular: true,
        //linearGradient: const LinearGradient(colors: [primaryColor]),
        opacityOfGradient: 0.4,
        padding: const EdgeInsets.all(2),
        size: 50,
      ),
    );
  }

//mark as current..
  tapped(int step) {
    setState(() => _currentStep = step);
  }

  //register function ..
  void _register() async {
    setState(() {
      _isLoading = true;
    });
    if (x == 1) {
      genderController.text = 'female';
    } else {
      genderController.text = 'male';
    }

    var data = {
      "f_name": firstnameController.text,
      "l_name": lastnameController.text,
      "gender": genderController.text,
      "password": passwordController.text,
      "email": emailController.text,
      "birthdate": datee.text,
      "phone": phoneController.text
    };

    var res = await CallApi().postData(data, 'register');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PatientBar(title: 'Wanas')));
    } else if (res.statusCode == 422) {
      setState(() {
        msg = body['errors'][0];
      });
    } else {
      setState(() {
        msg = body['messages'];
      });
    }

    setState(() {
      _isLoading = false;
    });
  }
}
