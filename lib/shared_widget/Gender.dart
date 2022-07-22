import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GenderField extends StatelessWidget {
  final List<String> genderList;
  var size, height, width;

  GenderField(this.genderList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    String? select;
    Map<int, String> mappedGender = genderList.asMap();

    return Container(
      width: width,
      height: height / 10,
     
      child: StatefulBuilder(
        builder: (_, StateSetter setState) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Gender : ',
              style: TextStyle(
                color: Colors.grey[750],
                fontSize: 15,
              ),
            ),
            ...mappedGender.entries.map(
              (MapEntry<int, String> mapEntry) {
                var select2 = select;
                return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(
                        activeColor: Theme.of(context).primaryColor,
                        groupValue: select2,
                        value: genderList[mapEntry.key],
                        onChanged: (value) =>
                            setState(() => select = value as String?),
                      ),
                      Text(mapEntry.value, style: TextStyle(fontSize: 12)),
                    ]);
              },
            ),
          ],
        ),
      ),
    );
  }
}