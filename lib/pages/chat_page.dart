import 'dart:io';

import 'package:chat/models/mensajes_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  bool _isWriting = false;

  List<ChatMessage> _messages = [];

  @override
  initState() {
    super.initState();

    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _listenMessage);
    _cargarHistorial(chatService.usuarioPara.uid);
  }

  _listenMessage(dynamic data) {
    ChatMessage message = ChatMessage(
        text: data['mensaje'],
        uid: data['de'],
        animationController:
            AnimationController(vsync: this, duration: Duration(milliseconds: 300)));
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('mensaje-personal');
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: Text(
                usuarioPara.name.substring(0, 2),
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 3),
            Text(usuarioPara.name, style: const TextStyle(color: Colors.black87, fontSize: 12))
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
        uid: authService.usuario.uid,
        animationController:
            AnimationController(vsync: this, duration: const Duration(milliseconds: 200)));
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _isWriting = false;
    });

    socketService.emit('mensaje-personal',
        {'de': authService.usuario.uid, 'para': chatService.usuarioPara.uid, 'mensaje': text});
  }

  Future<void> _cargarHistorial(String uid) async {
    List<Mensaje> chat = await chatService.getChat(uid);

    final history = chat.map((e) => ChatMessage(
        text: e.mensaje,
        uid: e.de,
        animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 0))
          ..forward()));

    setState(() {
      _messages.insertAll(0, history);
    });
  }
}
