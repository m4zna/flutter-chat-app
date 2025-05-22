import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uid;
  final AnimationController animationController;

  const ChatMessage(
      {super.key, required this.text, required this.uid, required this.animationController});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: uid == '123' ? _myMessage() : _notMyMessage(),
        ),
      ),
    );
  }

  _myMessage() {
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(0xff4D9EF6)),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(bottom: 5, right: 5, left: 50),
            child: Text(text, style: TextStyle(color: Colors.white))));
  }

  _notMyMessage() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(0xffe4e5e8)),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(bottom: 5, right: 50, left: 5),
            child: Text(text, style: TextStyle(color: Colors.black87))));
  }
}
