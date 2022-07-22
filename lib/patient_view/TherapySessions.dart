import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project/patient_view/view_therapist_details.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/therapistModel.dart';
import '../therapist_view/searchScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/my_api.dart';
import '../shared_widget/colors.dart';
import '../shared_widget/components/components.dart';
import 'bookSession.dart';

class AllTherapists extends StatefulWidget {
  @override
  State<AllTherapists> createState() => _TherapistsState();
}

class _TherapistsState extends State<AllTherapists> {
  var size, height, width;
  late Future<List<therapist>> therapists;

  @override
  void initState() {
    therapists = getTherapists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: width,
                height: height / 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey[300],
                ),
                padding: EdgeInsets.all(3.0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.search)),
                    SizedBox(
                      width: width / 25,
                    ),
                    defaultText(
                        text: 'Search', fontSize: 20, textColor: Colors.grey),
                  ],
                ),
              ),
              SizedBox(
                height: height / 100,
              ),
              defaultText(
                text: 'Choose a doctor to book with!',
                fontSize: 20.0,
                isBold: true,
              ),
              SizedBox(
                height: height / 100,
              ),
              Container(
                height: height,
                child: FutureBuilder<List<therapist>>(
                    future: therapists,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              SizedBox(
                                height: height / 100,
                              ),
                              Container(
                                color: Colors.white,
                                height: height,
                                child: ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) =>
                                      buildDoctorItem(
                                          snapshot.data![index].f_name,
                                          snapshot.data![index].l_name,
                                          snapshot.data![index].speciality,
                                          snapshot.data![index].rate,
                                          snapshot.data![index].experiance,
                                          snapshot.data![index].education,
                                          snapshot.data![index].id,
                                          snapshot.data![index].image,
                                          context),
                                ),
                              ),
                            ],
                          );
                        });
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<therapist>> getTherapists() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
    };

    var res = await CallApi().postData(data, 'patient/viewTherapists');
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      List<therapist> therap = [];
      for (var u in body) {
        therapist p = therapist(
            f_name: u['f_name'],
            l_name: u['l_name'],
            id: u['id'],
            email: u['email'],
            phone: u['phone'],
            education: u['education'],
            rate: double.parse(u['rate']),
            experiance: u['experiance'],
            speciality: u['speciality'],
            image: u['image']);
        print(u['experiance']);
        therap.add(p);
      }
      return therap;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Widget buildDoctorItem(
          var f_name,
          var l_name,
          var speciality,
          var rate,
          var experiance,
          var education,
          var id,
          var image,
          BuildContext context) =>
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            width: width,
            height: height / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.white,
              border: Border.all(
                width: 2,
                color: primaryColor,
                style: BorderStyle.solid,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              defaultText(
                                text: f_name + ' ' + l_name,
                                textColor: primaryColor,
                                fontSize: 20.0,
                                isBold: true,
                              ),
                              SizedBox(
                                height: height / 90,
                              ),
                              defaultText(
                                text: speciality != null
                                    ? 'Speciality: \n' + speciality
                                    : '',
                                textColor: primaryColor,
                                fontSize: 17.0,
                                isBold: true,
                              ),
                              SizedBox(
                                height: height / 70,
                              ),
                              RatingBar(
                                  initialRating: rate,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 25,
                                  ratingWidget: RatingWidget(
                                      full: const Icon(Icons.star,
                                          color: rateColor),
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
                            ]),
                      ),
                      SizedBox(width: width / 16),
                      CircleAvatar(
                        radius: 55.0,
                        backgroundImage:
                            AssetImage('assets/images/therapist.png'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      defaultButton(
                          width: 100,
                          background: primaryColor,
                          function: () {
//                             calculateAge(DateTime birthDate) {
//   DateTime currentDate = DateTime.now();
//   int age = currentDate.year - birthDate.year;
//   int month1 = currentDate.month;
//   int month2 = birthDate.month;
//   if (month2 > month1) {
//     age--;
//   } else if (month1 == month2) {
//     int day1 = currentDate.day;
//     int day2 = birthDate.day;
//     if (day2 > day1) {
//       age--;
//     }
//   }
//   return age;
// }
// final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
//   DateTime currentDate = serverFormater.parse('1998-11-28');
//   print(calculateAge(currentDate));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => viewTherapistDetails(
                                    id: id,
                                    f_name: f_name,
                                    l_name: l_name,
                                    rate: rate,
                                    education: education,
                                    speciality: speciality,
                                    experiance: experiance,
                                    image: image),
                              ),
                            );
                          },
                          text: 'Details'),
                      SizedBox(
                        width: width / 30,
                      ),
                      defaultButton(
                          width: 155.0,
                          background: primaryColor,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => bookSession(
                                    therapist_id: id,
                                    f_name: f_name,
                                    l_name: l_name,
                                    image: image),
                              ),
                            );
                          },
                          text: 'Book Session')
                    ],
                  ),
                ],
              ),
            ),
          ));
}
