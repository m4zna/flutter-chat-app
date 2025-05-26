import 'package:chat/models/user.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../services/socket_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final usuariosService = UsuariosService();
  List<Usuario> users = [];

  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final usuario = authService.usuario;
    return Scaffold(
      appBar: AppBar(
          title: Text(usuario.name, style: TextStyle(color: Colors.black54)),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.black54),
            onPressed: () {
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
          ),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: socketService.serverStatus == ServerStatus.Online
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.blue[400],
                      )
                    : Icon(
                        Icons.offline_bolt,
                        color: Colors.red,
                      ))
          ]),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400]!,
        ),
        onRefresh: () async {
          _loadUsers();
        },
        child: _listViewUsers(),
      ),
    );
  }

  ListView _listViewUsers() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) => _userListTile(users[i]),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: users.length);
  }

  ListTile _userListTile(Usuario user) {
    return ListTile(
      onTap: ()=>_messages(user),
        title: Text(user.name),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text( user.name.substring(0,2)),
        ),
        trailing: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: user.online ? Colors.green[300] : Colors.red,
              borderRadius: BorderRadius.circular(100),
            )));
  }

  _loadUsers() async {
    final usuarios = await usuariosService.getUsuarios();
    users.clear();
    users.addAll(usuarios);
    setState(() {});
    _refreshController.refreshCompleted();
  }

  _messages (Usuario user){
    final chatService = Provider.of<ChatService>(context, listen: false);
    chatService.usuarioPara = user;
    Navigator.pushNamed(context, 'chat' );
  }


}
