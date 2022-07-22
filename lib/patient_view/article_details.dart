import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/shared_widget/components/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend/my_api.dart';
import '../shared_widget/colors.dart';
import '../shared_widget/small_text.dart';

class ArticlesDetails extends StatefulWidget {
  final String content;
  final String image;
  final int id;
  const ArticlesDetails({
    Key? key,
    required this.content,
    required this.image,
    required this.id,
  }) : super(key: key);

  @override
  State<ArticlesDetails> createState() =>
      _ArticlesDetailsState(content: content, image: image, id: id);
}

class _ArticlesDetailsState extends State<ArticlesDetails> {
  final String content;
  final String image;
  final int id;
  var isFavourite;

  var size, height, width;
  _ArticlesDetailsState(
      {required this.content, required this.image, required this.id});

  @override
  void initState() {
    super.initState();
    checkfavouriteAwareness(id);
  }

  @override
  Widget build(BuildContext context) {
    var x = content.split('.');
    String contentLines = getNewLineString(x);
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: defaultText(
          text: 'Awareness',
          fontSize: 20.0,
          isBold: true,
          textColor: Colors.white,
        ),
        backgroundColor: primaryColor,
        leading: const BackButton(),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: width * (80 / 100)),
                  Container(
                    //margin: const EdgeInsets.only(left: 350),
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite_border_outlined,
                        size: 30,
                        color: isFavourite != false && isFavourite != null
                            ? secondaryColor
                            : primaryColor,
                      ),
                      onPressed: () {
                        if (isFavourite == false) {
                          addfavouriteAwareness(context, id);
                        } else {
                          removefavouriteAwareness(id);
                        }
                        setState(() {
                          isFavourite = !isFavourite;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 200, //Dimentions.popularArticlesImgSize,
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: primaryColor,
                      style: BorderStyle.solid,
                    ),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/" + image))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: defaultText(
                      text: contentLines.replaceAll('', ''), fontSize: 15.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addfavouriteAwareness(BuildContext context, id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
      "awareness_id": id,
    };

    var res = await CallApi().postData(data, 'awareness/addfavouriteAwareness');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      if (body['message'] == true) {
        setState(() {
          isFavourite = true;
        });
      } else {
        isFavourite = false;
      }
    } else {
      print(body['message']);
    }
  }

  void checkfavouriteAwareness(id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
      "awareness_id": id,
    };

    var res =
        await CallApi().postData(data, 'awareness/checkFavouriteAwareness');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      if (body['message'] == true) {
        setState(() {
          isFavourite = true;
        });
      } else {
        isFavourite = false;
      }
    } else {
      print(body['message']);
    }
  }

  String getNewLineString(readLines) {
    StringBuffer sb = new StringBuffer();
    for (String line in readLines) {
      sb.write(line + "\n");
    }
    return sb.toString();
  }

  void removefavouriteAwareness(id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
      "awareness_id": id,
    };

    var res =
        await CallApi().postData(data, 'awareness/removefavouriteAwareness');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      if (body['message'] == true) {
        setState(() {
          isFavourite = false;
        });
      } else {
        isFavourite = true;
      }
    } else {
      print(body['message']);
    }
  }
}
