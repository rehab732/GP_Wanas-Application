import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/patient_view/mood_chart.dart';
import 'package:flutter_project/shared_widget/components/components.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend/my_api.dart';

class RecordMood extends StatefulWidget {
  @override
  State<RecordMood> createState() => _RecordMoodState();
}

class _RecordMoodState extends State<RecordMood> {
  @override
  var moodController = TextEditingController();
  var rate;
  var size, height, width;
  var msg;
  bool _isLoading = false;

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
        appBar: AppBar(
          title: defaultText(
              text: 'Mood', fontSize: 20.0, textColor: Colors.white),
          backgroundColor: Color(0xFF385DA6),
        ),
        body: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.0,
              ),
              defaultText(
                text: 'Enter your current mood',
                fontSize: 20.0,
                textColor: Color(0xFF385DA6),
                isBold: true,
              ),
              SizedBox(
                height: 30.0,
              ),
              Center(
                child: RatingBar.builder(
                  initialRating: 0,
                  itemCount: 5,
                  minRating: 1,
                  itemSize: 60.0,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Column(
                          children: [
                            const Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: Color(0xFFFF929E),
                              size: 50.0,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            defaultText(text: 'Awful', fontSize: 20.0)
                          ],
                        );
                      case 1:
                        return Column(
                          children: [
                            const Icon(
                              Icons.sentiment_dissatisfied,
                              color: Color(0xFFF9AD7B),
                              size: 50.0,
                            ),
                            defaultText(text: 'Bad', fontSize: 20.0)
                          ],
                        );
                      case 2:
                        return Column(
                          children: [
                            const Icon(
                              Icons.sentiment_neutral,
                              color: Color(0xFF4DA4D6),
                              size: 50.0,
                            ),
                            defaultText(text: 'Okay', fontSize: 20.0)
                          ],
                        );
                      case 3:
                        return Column(
                          children: [
                            const Icon(
                              Icons.sentiment_satisfied,
                              color: Color(0xFFD6B1E7),
                              size: 50.0,
                            ),
                            defaultText(text: 'Good', fontSize: 20.0)
                          ],
                        );
                      case 4:
                        return Column(
                          children: [
                            const Icon(
                              Icons.sentiment_very_satisfied,
                              color: Color(0xFF64CDBC),
                              size: 50.0,
                            ),
                            defaultText(text: 'Great', fontSize: 20.0)
                          ],
                        );
                      default:
                        return const Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.green,
                        );
                    }
                  },
                  onRatingUpdate: (rating) {
                    rate = rating;
                  },
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                width: 350.0,
                child: TextFormField(
                  controller: moodController,
                  keyboardType: TextInputType.text,
                  minLines: 6,
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText:
                          'Enter comments about what you are doing,\n thinking and feeling',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 3, color: Color(0xFF385DA6)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        //borderSide: const BorderSide(width: 3, color: Colors.red),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              defaultButton(
                width: 200.0,
                function: () {
                  RecordMood();
                },
                text: !_isLoading ? "Save" : "Saving ..",
              ),
              SizedBox(
                height: 20,
              ),
              defaultText(
                  text: msg != null ? msg : '', fontSize: 16, isBold: true),
            ],
          ),
        ));
  }

  void RecordMood() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
      "content": moodController.text,
      "value": rate,
    };

    var res = await CallApi().postData(data, 'mood/RecordMood');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      msg = body['message'];
    } else {
      msg = body['message'];
    }
    setState(() {
      _isLoading = false;
    });
  }
}
