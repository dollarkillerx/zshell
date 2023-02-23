import 'package:flutter/material.dart';

import '../constants/colors.dart';

// class IButton extends StatefulWidget {
//   final bool action;
//   const IButton({Key? key, required this.action}) : super(key: key);
//
//   @override
//   State<IButton> createState() => _IButtonState(action);
// }
//
// class _IButtonState extends State<IButton> {
//   var action = false;
//
//   _IButtonState(this.action);
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }


Widget IButton(IconData icon, String text, bool action, GestureTapCallback onTap) {
  return InkWell(
    onTap: onTap,
    highlightColor: Colors.white,
    child: Container(
      height: 40,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: Style.kTextLight,
          )
        ],
      ),
      decoration: action
          ? BoxDecoration(
          color: Color(0xff2B2D3C),
          borderRadius: BorderRadius.circular(10))
          : BoxDecoration(),
    ),
  );
}