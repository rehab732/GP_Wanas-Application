import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/my_api.dart';
import '../models/moodModel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MoodChart extends StatefulWidget {
  @override
  State<MoodChart> createState() => _MoodChartState();
}

class _MoodChartState extends State<MoodChart> {
  late Future<List<Mood>> data;
  late List<Mood> listMoodNot = [];
  late List<Mood> listMood = [];

  @override
  void initState() {
    super.initState();
    data = ReturnMood();
    x(data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9.0),
      width: double.infinity,
      child: Column(
        children: [
          listMood != null && listMood.isNotEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(9.0),
                  child: Center(
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(text: 'Weekly Mood Analysis'),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      plotAreaBackgroundColor: Colors.white,
                      series: <ChartSeries<Mood, String>>[
                        LineSeries<Mood, String>(
                            dataSource: listMood,
                            xValueMapper: (Mood mood, _) => mood.date,
                            yValueMapper: (Mood mood, _) => mood.value,
                            name: 'Mood',
                            color: Color(0xFFFF8EB7),
                            markerSettings: MarkerSettings(
                              color: Color(0xFFFF8EB7),
                              shape: DataMarkerType.circle,
                              borderColor: Color(0xFFFF8EB7),
                              borderWidth: 1.0,
                              isVisible: true,
                            )
                        )
                      ],
                    ),
                  ),
                )
              : SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: 'Weekly Mood Analysis'),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  plotAreaBackgroundColor: Colors.white,
                ),
          //: CircularProgressIndicator()
        ],
      ),
    );
  }

  void x(data) async {
    listMoodNot = await data;

    setState(() {
      listMood = listMoodNot;
    });
  }

  Future<List<Mood>> ReturnMood() async {
    List<Mood> moood = [];

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var data = {
      "token": token,
    };

    var res = await CallApi().postData(data, 'mood/ReturnMood');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      for (var u in body) {
        Mood mode = Mood(
            id: u['id'],
            content: u['content'],
            value: int.parse(u['value']),
            date: u['date'],
            time: u['time'],
            patient_id: int.parse(u['patient_id']));
        moood.add(mode);
      }

      return moood;
    } else {
      return moood;
    }
  }
}
