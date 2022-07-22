import 'package:flutter/cupertino.dart';

import 'colors.dart';

class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  double size;

  SmallText(
      {Key? key,
      this.color = secondaryColor,
      required this.text,
      this.size = 20,
     })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
       margin: EdgeInsets.only(
                                  left: 10),
      child: Text(
        text,
        
        style: TextStyle(
            //fontFamily: 'Roboto',
             fontSize: size, color: color),
             
      ),
    );
  }
}
