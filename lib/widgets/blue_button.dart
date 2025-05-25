import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const BlueButton({super.key,required this.text,  required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor: Colors.blue,
          shape: const StadiumBorder(),
        ),
        onPressed:() => onPressed(),
        child:  SizedBox(
          width: double.infinity,
          height: 55,
          child: Center(
              child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
        ));
  }
}
