import 'package:flutter/material.dart';
import '../../shared_widget/colors.dart';


Widget defaultButton({
  required double width,
  Color background = const Color(0xFF385DA6),
  required Function() function,
  required String text,
}) => Container(
      width: width,
      height: 40.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(70.0),
        color: background,
      ),
    );

Widget defaultText({
  required String text,
  required double fontSize,
  Color textColor = const Color(0xFF385DA6),
  bool isBold = false,
}) => Text(
      text,
      style: TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: fontSize,
        color: textColor,
        
      ),
    );

Widget buildMenuItem({
  required String text,
  required IconData icon,
  VoidCallback? onClicked,
}) {
  final color = Colors.white;
  final hoverColor = Colors.white70;

  return ListTile(
    leading: Icon(icon, color: color),
    title: Text(text, style: TextStyle(color: color)),
    hoverColor: hoverColor,
    onTap: onClicked,
  );
}
class menuItem extends StatelessWidget {
  const menuItem({
    Key? key,
    required this.text,
    required this.first_icon,
    required this.press,

  }) : super(key: key);
  final String text;
  final VoidCallback press;
  final IconData first_icon;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20.0),
        color: Color(0xFFF5F6F9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: press,
        child: Row(
          children: [
            Icon(
              first_icon,
              color: Color(0xFF001E6C),
              size: 25,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                      color: Color(0xFF001E6C),
                      fontWeight: FontWeight.normal,
                      fontSize: 17),
                )),
            Icon(
              Icons.arrow_forward_ios,

              color: Color(0xFF001E6C),
            ),
          ],
        ),
      ),
    );
  }
}