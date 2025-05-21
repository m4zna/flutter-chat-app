import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final Function onPressed;

  const BlueButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor: Colors.blue,
          shape: const StadiumBorder(),
        ),
        onPressed: onPressed(),
        child: const SizedBox(
          width: double.infinity,
          height: 55,
          child: Center(
              child: Text(
            'Ingresar',
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
        ));
  }
}
