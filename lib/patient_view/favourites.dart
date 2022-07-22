import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../shared_widget/big_text.dart';
import '../patient_view/article_details.dart';
import '../shared_widget/components/components.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/awarenessModel.dart';
import '../backend/my_api.dart';
import '../shared_widget/colors.dart';
import '../shared_widget/small_text.dart';

class Favourites extends StatefulWidget {
  const Favourites({
    Key? key,
  }) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  late Future<List<Awareness>> awareness;
  var rate;
  var size, height, width;
  @override
  void initState() {
    super.initState();
    awareness = getfavouriteAwarenessList();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
        appBar: AppBar(
            title: defaultText(
                text: 'My Favourite Articles',
                textColor: Colors.white,
                fontSize: 20.0,
                isBold: true),
            backgroundColor: primaryColor,
            leading: BackButton()),
        body: _buildPageItem());
  }

  Widget _buildPageItem() {
    return Container(
      color: Colors.white,
      child: FutureBuilder<List<Awareness>>(
          future: awareness,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.length != 0
                  ? ListView.builder(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 160.0,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      "assets/images/" +
                                                          snapshot.data![index]
                                                              .image))),
                                        ),
                                        Divider(
                                            color: primaryColor,
                                            thickness: 1.0),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        defaultText(
                                            text: snapshot.data![index].type,
                                            fontSize: 25.0,
                                            isBold: true),
                                        SizedBox(height: 10.0),
                                        Text(
                                          snapshot.data![index].title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        RatingBar(
                                            initialRating:
                                                snapshot.data![index].rate,
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
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ));
                      })
                  : defaultText(
                      text: "No Awareness Found",
                      fontSize: 20,
                      textColor: primaryColor);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<List<Awareness>> getfavouriteAwarenessList() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
    };
    var response =
        await CallApi().postData(data, 'awareness/getfavouriteAwarenessList');
    List<Awareness> awar = [];
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);

      for (var u in jsonResponse) {
        Awareness user = Awareness(
            title: u['title'],
            rate: double.parse(u['rate']),
            id: u['id'],
            image: u['image'],
            content: u['content'],
            type: u['type']);
        awar.add(user);
      }
      return awar;
    } else {
      return awar;
    }
  }
}
