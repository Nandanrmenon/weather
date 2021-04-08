import 'package:flutter/material.dart';

import '../constants.dart';

class RSTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType type;
  final bool obscureText;
  final int maxLength;
  final int maxLines;
  final Icon icon;

  const RSTextField(
      {Key key,
        @required this.hint,
        this.controller,
        this.type,
        this.obscureText,
        this.maxLength,
        this.maxLines,
        this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 1.0),
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: new Row(
        children: [
          Visibility(
            child: icon ?? Container(),
            visible: icon != null,
          ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: new TextField(
              controller: controller,
              keyboardType: type,
              obscureText: obscureText ?? false,
              maxLength: maxLength ?? null,
              maxLines: maxLines ?? null,
              textCapitalization: (type == TextInputType.emailAddress
                  ? TextCapitalization.none
                  : TextCapitalization.sentences),
              style: TextStyle(height: 1.0),
              decoration: new InputDecoration.collapsed(
                hintText: hint,
              ),
            ),
          ),
          // Container(
          //   padding: EdgeInsets.all(5.0),
          //   child: ConstrainedBox(
          //     constraints: BoxConstraints.tightFor(width: 50, height: 40),
          //     child: ElevatedButton(
          //       child: Icon(Icons.send_rounded),
          //       onPressed: () {},
          //       style: ElevatedButton.styleFrom(
          //         shape: CircleBorder(),
          //         primary: kPrimaryColor,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
