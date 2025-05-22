import 'package:flutter/material.dart';

class Labels extends StatefulWidget {
  final String route;
  final String title;
  final String subtitle;

  const Labels({super.key, required this.route, required this.title, required this.subtitle});


  @override
  State<Labels> createState() => _LabelsState();
}

class _LabelsState extends State<Labels> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Text(
          widget.title,
          style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, widget.route);
          },
          child: Text(widget.subtitle,
              style: TextStyle(fontSize: 18, color: Colors.blue[600], fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}


