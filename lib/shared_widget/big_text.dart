import 'package:flutter/cupertino.dart';

import 'colors.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overflow;
  BigText(
      {Key? key,
      this.color = secondaryColor,
      required this.text,
      this.size = 20,
      this.overflow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overflow,
      style: TextStyle(
          //fontFamily: 'Roboto',
          fontSize: size,
          color: color,
          fontWeight: FontWeight.w500),
    );
  }
}
