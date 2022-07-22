import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project/shared_widget/components/components.dart';
import '../shared_widget/colors.dart';
import '../patient_view/article_details.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/my_api.dart';
import '../Models/awarenessModel.dart';

class MainAwarenessPage extends StatefulWidget {
  const MainAwarenessPage({Key? key}) : super(key: key);

  @override
  State<MainAwarenessPage> createState() => _MainAwarenessPageState();
}

class _MainAwarenessPageState extends State<MainAwarenessPage> {
  late Future<List<Awareness>> awareness;
  var size, height, width;
  //late Future<dynamic> Awar;
  var rate;
  @override
  void initState() {
    super.initState();
    awareness = getAwareness();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(body: _buildPageItem());
  }

  Widget _buildPageItem() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: FutureBuilder<List<Awareness>>(
          future: awareness,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticlesDetails(
                              content: snapshot.data![index].content,
                              image: snapshot.data![index].image,
                              id: snapshot.data![index].id,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15.0),
                            height: height / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                width: 2,
                                color: primaryColor,
                                style: BorderStyle.solid,
                              ),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 160.0,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage("assets/images/" +
                                                snapshot.data![index].image))),
                                  ),
                                  Divider(color: primaryColor, thickness: 1.0),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  defaultText(
                                    text: snapshot.data![index].type,
                                    fontSize: 20.0,
                                    isBold: true,
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    snapshot.data![index].title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  RatingBar(
                                      initialRating: snapshot.data![index].rate,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 27,
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  void rateAwareness() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
      "rate": rate,
    };

    var res = await CallApi().postData(data, 'awareness/rateAwareness');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
    } else {
      print(body['message']);
    }
  }

  Future<List<Awareness>> getAwareness() async {
    List<Awareness> awar = [];

    var response = await CallApi().getData('awareness');
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      for (var u in jsonResponse) {
        Awareness user = Awareness(
            rate: double.parse(u['rate']),
            id: u['id'],
            content: u['content'],
            title: u['title'],
            image: u['image'],
            type: u['type']);
        awar.add(user);
      }
      return awar;
    } else {
      return awar;
    }
  }
}
