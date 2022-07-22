// @dart=2.12
import 'package:flutter/material.dart';
import '../patient_view/bookSession.dart';
import '../models/therapistModel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../shared_widget/components/components.dart';
import '../shared_widget/colors.dart';
import '../shared_widget/profile_widgt.dart';

class viewTherapistDetails extends StatefulWidget {
  String f_name;
  String l_name;
  String education;
  String experiance;
  var rate;
  String speciality;
  String image;
  int id;

  viewTherapistDetails(
      {Key? key,
      required this.id,
      required this.f_name,
      required this.l_name,
      required this.rate,
      required this.education,
      required this.speciality,
      required this.experiance,
      required this.image})
      : super(key: key);

  @override
  State<viewTherapistDetails> createState() => _viewTherapistDetailsState(
      id: this.id,
      f_name: this.f_name,
      l_name: this.l_name,
      rate: this.rate,
      education: this.education,
      speciality: this.speciality,
      experiance: this.experiance,
      image: this.image);
}

class _viewTherapistDetailsState extends State<viewTherapistDetails> {
  String f_name;
  String l_name;
  String education;
  String experiance;
  var rate;
  int id;
  String image;
  String speciality;

  _viewTherapistDetailsState(
      {Key? key,
      required this.id,
      required this.f_name,
      required this.l_name,
      required this.rate,
      required this.education,
      required this.speciality,
      required this.experiance,
      required this.image});

  @override
  void initState() {
    super.initState();
  }

  var size, height, width;
  String getNewLineString(readLines) {
    StringBuffer sb = new StringBuffer();
    for (String line in readLines) {
      sb.write(line + "\n");
    }
    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    print(experiance);

    var x = experiance.split(',');
    var y = education.split(',');
    education = getNewLineString(y);
    experiance = getNewLineString(x);
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: defaultText(
          text: 'Therapist details',
          fontSize: 20.0,
          isBold: true,
          textColor: Colors.white,
        ),
        backgroundColor: primaryColor,
        leading: BackButton(),
        elevation: 5,
      ),
      body: therapist != null
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55.0,
                      backgroundImage:
                          AssetImage('assets/images/therapist.png'),
                    ),
                    SizedBox(height: height / 90),
                    defaultText(
                        text: f_name + ' ' + l_name,
                        isBold: true,
                        fontSize: 24),
                    SizedBox(height: height / 50),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(
                          width: 2,
                          color: primaryColor,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height / 50),
                          RatingBar(
                              initialRating: rate,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 27,
                              ratingWidget: RatingWidget(
                                  full:
                                      const Icon(Icons.star, color: rateColor),
                                  half: const Icon(
                                    Icons.star_half,
                                    color: rateColor,
                                  ),
                                  empty: const Icon(
                                    Icons.star_outline,
                                    color: rateColor,
                                  )),
                              onRatingUpdate: (value) {
                                setState(() {
                                  rate = value;
                                  // rateAwareness();
                                });
                              }),
                          SizedBox(height: height / 50),
                          defaultText(
                            text: 'Speciality: ' ,
                            fontSize: 22,
                            isBold: true
                          ),
                          defaultText(text: speciality,
                              fontSize: 20.0),
                          SizedBox(height: height / 50),
                          defaultText(
                            text: 'Experience: ' ,
                            fontSize: 22,
                            isBold: true
                          ),
                          defaultText(
                            text:  experiance,
                            fontSize: 20,
                          ),
                          SizedBox(height: height / 50),
                          defaultText(
                            text: 'Education: ' ,
                            fontSize: 22,
                            isBold: true
                          ),
                          defaultText(
                            text: 'Education: ' + education,
                            fontSize: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    defaultButton(
                        width: width / 2,
                        background: primaryColor,
                        function: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => bookSession(
                                therapist_id: id,
                                l_name: f_name,
                                f_name: l_name,
                                image: image,
                              ),
                            ),
                          );
                        },
                        text: 'Book Now')
                  ],
                ),
              ),
            )
          : Center(child: const CircularProgressIndicator()),
    );
  }
}
