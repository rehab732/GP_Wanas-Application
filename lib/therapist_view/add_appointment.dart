import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/shared_widget/colors.dart';
import 'package:flutter_project/shared_widget/components/components.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/my_api.dart';
import 'YourSchedule.dart';

class AddAppointment extends StatefulWidget {
  const AddAppointment({Key? key}) : super(key: key);

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  int _activeStepIndex = 0;
  TextEditingController date = TextEditingController();
  TextEditingController start = TextEditingController();
  TextEditingController end = TextEditingController();
  var formkey = GlobalKey<FormState>();
  var formkey1 = GlobalKey<FormState>();
  var formkey2 = GlobalKey<FormState>();
  var height, width, size;
  var msg;
  bool _isLoading = false;

  List<Step> StepList() => [
        Step(
          state: GetDateState(),
          // _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          content: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: date,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.calendar_month_rounded,
                        color: primaryColor,
                        size: 30,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: primaryColor,
                          size: 35,
                        ),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2023),
                          ).then((value) {
                            final dateFormat = DateFormat('yyyy-mm-dd');

                            final x = dateFormat.parse(value.toString());

                            final String formatted = dateFormat.format(x);
                            date.text = formatted;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      labelText: 'Date',
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          title: defaultText(text: 'Date', fontSize: 17, isBold: true),
        ),
        Step(
          state: GetTimestate(),
          isActive: _activeStepIndex >= 1,
          content: SingleChildScrollView(
            child: Form(
              key: formkey1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: start,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.watch_later,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: primaryColor,
                          size: 30,
                        ),
                        onPressed: () {
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((value) {
                            start.text = value!.format(context).toString();
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      labelText: 'Start Time',
                      labelStyle:
                          TextStyle(color: primaryColor, fontSize: 20.0),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: end,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.watch_later,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: primaryColor,
                          size: 30,
                        ),
                        onPressed: () {
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((value) {
                            end.text = value!.format(context).toString();
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      labelText: 'End Time',
                      labelStyle:
                          TextStyle(color: primaryColor, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          title: defaultText(text: 'Time', fontSize: 17, isBold: true),
        ),
        Step(
          state: GetFinalState(),
          isActive: _activeStepIndex >= 2,
          content: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                height: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Colors.white,
                  border: Border.all(
                    width: 2,
                    color: primaryColor,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        defaultText(
                            text: 'Session Date :',
                            fontSize: 17.0,
                            isBold: true),
                        SizedBox(
                          width: 10,
                        ),
                        defaultText(text: '${date.text}', fontSize: 17.0),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        defaultText(
                            text: 'Session Start Time :',
                            fontSize: 17.0,
                            isBold: true),
                        SizedBox(
                          width: 10,
                        ),
                        defaultText(text: '${start.text}', fontSize: 17.0),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        defaultText(
                            text: 'Session End Time :',
                            fontSize: 17.0,
                            isBold: true),
                        SizedBox(
                          width: 10,
                        ),
                        defaultText(text: '${end.text}', fontSize: 17.0),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Center(
                child: defaultText(
                      text: msg!= null ? msg : ' ',
                      fontSize: 20,
                      textColor: Colors.red,
                    ),
              ),
                  SizedBox(
                    height: 15.0,
                  ),
            ]),
          ),
          title: defaultText(text: 'Confirm', fontSize: 17, isBold: true),
        ),

      ];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      body: SafeArea(
        child: Theme(
          data: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: primaryColor,
                ),
          ),
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _activeStepIndex,
            steps: StepList(),
            onStepContinue: _activeStepIndex < StepList().length - 1
                ? continued
                : GetFinalState() == StepState.error
                    ? GetErrorMsg()
                    : finalStep,
            onStepCancel: cancel,
          ),
        ),
      ),
      //   Text(''),
    );
  }

  GetDateState() {
    if (date.text.isNotEmpty && _activeStepIndex != 0) {
      return StepState.complete;
    } else if (_activeStepIndex == 0) {
      return StepState.editing;
    } else {
      return StepState.error;
    }
  }

  GetTimestate() {
    if (_activeStepIndex > 1) {
      if (start.text.isEmpty) {
        setState(() {
          msg = 'Please Choose Start Time';
        });
        return StepState.error;
      }
      if (end.text.isEmpty) {
        setState(() {
          msg = 'Please Choose End Time';
        });
        return StepState.error;
      }
      return StepState.complete;
    } else if (_activeStepIndex == 1) {
      return StepState.editing;
    } else if (_activeStepIndex < 1) {
      return StepState.indexed;
    } else {
      return StepState.error;
    }
  }

  //containue to second step ..

  continued() {
    _activeStepIndex < StepList().length
        ? setState(() => _activeStepIndex += 1)
        : null;
  }

//call register function ..
  finalStep() {
    addAppiontment();
  }

//return back one step ..
  cancel() {
    setState(() {
      msg = '';
    });

    _activeStepIndex > 0 ? setState(() => _activeStepIndex -= 1) : null;
  }

  GetErrorMsg() {
    setState(() {
      msg = 'Please fill all fields';
    });
  }

  GetFinalState() {
    if (_activeStepIndex < 3) {
      return StepState.indexed;
    }
    if (date.text.isNotEmpty && start.text.isNotEmpty && end.text.isNotEmpty) {
      return StepState.complete;
    } else {
      return StepState.error;
    }
  }

  void addAppiontment() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var data = {
      "token": token,
      "date": date.text,
      "startTime": start.text,
      "endTime": end.text,
    };

    var res = await CallApi().postData(data, 'appiontment/addAppiontment');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      msg = body['message'];
      print(msg);
    } else {
      msg = body['message'];
      print(body);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
