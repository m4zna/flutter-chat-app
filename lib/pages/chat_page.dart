import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isWriting = false;

  List<ChatMessage> _messages = [];

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: const Text(
                'Us',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 3),
            const Text('User', style: TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(children: [
        Flexible(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _messages.length,
            itemBuilder: (_, i) => _messages[i],
            reverse: true,
          ),
        ),
        const Divider(height: 1),
        Container(
          color: Colors.white,
          child: _inputChat(),
        )
      ]),
    );
  }

  _inputChat() {
    return SafeArea(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(children: [
              Flexible(
                  child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                onSubmitted: _handleSubmitted,
                onChanged: (text) {
                  setState(() {
                    _isWriting = text.trim().isNotEmpty;
                  });
                },
                decoration: const InputDecoration.collapsed(hintText: 'Enviar mensaje'),
              )),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Platform.isIOS
                    ? CupertinoButton(
                        onPressed:
                            _isWriting ? () => _handleSubmitted(_textController.text.trim()) : null,
                        child: const Text('Enviar'),
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: IconTheme(
                          data: IconThemeData(color: Colors.blue[400]),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Icon(Icons.send, color: Colors.blue[400]),
                            onPressed: _isWriting
                                ? () => _handleSubmitted(_textController.text.trim())
                                : null,
                          ),
                        ),
                      ),
              )
            ])));
  }

  _handleSubmitted(String text) {
    if (text.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessage(
        text: text,
        uid: '123',
        animationController:
            AnimationController(vsync: this, duration: const Duration(milliseconds: 200)));
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _isWriting = false;
    });
  }
}
